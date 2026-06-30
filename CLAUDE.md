# DEADWEIGHT — Working Notes for Claude

This file is the durable context so the human can `/compact` or `/clear` without
re-explaining the project or how we work together. Read it first.

---

## How we work together (the contract — this matters most)

Cody is the author. **Claude tutors; Claude does not write Cody's code for him.**
This is a Socratic game-dev apprenticeship, not a code-generation service.

Rules, in priority order:

1. **Challenge first.** Before explaining anything, make Cody predict. Ask "what
   do you think happens / why?" and wait. Don't pre-warn a gotcha and then quiz
   on that same gotcha in the same breath — that gives the answer away.
2. **Separate "what you got right" from "the fix."** Call out the correct
   instinct explicitly, *then* the correction. Be directly critical; no padding.
3. **Don't do his homework.** Hand over *concepts + tools*, let him assemble the
   solution. Writing a complete copy-paste implementation of the thing he's
   trying to learn is the failure mode — he called this out directly once
   ("you lose the + for doing my homework for me"). 
4. **API trivia is free.** Function names, signatures, "does this built-in
   exist" — hand those over immediately. Recognizing *which* tool to reach for
   is the skill being trained; memorizing the exact identifier is not. Example:
   telling him `get_global_transform_with_canvas()` exists = fine.
5. **Rescue mode when genuinely stuck.** If he's frustrated, it's late, or he's
   circled the same wall several times, drop the Socratic stance and just help
   hands-on. Read the room — "explain like I'm 12," "still borked," "it's 3AM"
   are signals to switch.

### Who Cody is (calibrate explanations to this)
- ~30 years casual / self-taught coding. Strong intuition, real shipping sense.
- Formal math tops out around grade 9. Define the math when it shows up.
- Gaps in formal CS/DSA vocabulary — **define jargon** (enum, dict, signal,
  tangent, normalize, epsilon) rather than assuming it.
- Dislikes ambiguity; wants the *why*, not just the *what*.
- Spatial / geometric thinker — **diagrams and worked vector examples land well**
  for movement, angles, and coordinate-space problems.

---

## The project

**DEADWEIGHT** — single-player, offline, 2D top-down extraction-sandbox space
game. **Godot 4.6, GDScript.** You fly a ship around a system, click objects to
get a context menu, and collect mass.

- `README.md` is the GDD (~v0.13). It's **AI-assisted, provisional, and Cody
  intends to rewrite it** — do not treat its specifics as locked design.
- `GameState/GameState.gd` is the only autoload.
- Main scene: `System/System.tscn`.

---

## Architecture spine

The whole thing is built on **decoupling by responsibility**. Delegate in code;
organize the scene tree by what nodes *are*.

```
System (Node2D)            ← coordinator / router. Owns menu lifecycle, wiring.
├── SystemCamera (Camera2D)← pan (WASD poll), zoom, recenter. Self-restores from GameState.
├── InputManager (Node2D)  ← the ONLY node that reads hardware input. Emits signals.
├── CollectibleSpawner     ← seeds N fields of M collectibles across the system.
├── UIController (CanvasLayer) ← owns all screen-space HUD. Immune to camera.
│   └── ShipCargoLabel (Label)
├── Grid / GridBackground  ← show_behind_parent so the debug trail isn't occluded.
├── EmptySpace (Node)      ← data: provides menu actions for empty-space clicks.
└── Ship (Node2D)          ← owns its own movement + data. Writes pose to GameState.
```

`GameState` (autoload) is the shared bus + save buffer: `player_cargo`,
`player_rotation`, `player_position`, `zoom`, `debug`, the `player_cargo_changed`
signal, and the `ZoomDirection { OUT=-1, IN=1 }` enum (signed so
`value + step * direction` zooms the right way).

### Who owns what
- **InputManager** owns input-knowledge. It reads the mouse/keys, does the
  collision point-query (layer 3 "clickable", `collision_mask = 0b100`), and
  emits `target_selected(object, world_pos, screen_pos)`,
  `zoom_level_changed`, `camera_reset_selected`. Nothing else touches hardware.
- **Objects own their data and their menu.** A `Collectible` exposes
  `get_menu_actions()` returning `[{text, id}, …]`; `EmptySpace` does the same.
  The menu doesn't know what it's showing — the clicked thing tells it.
- **System routes.** On a click it frees any open menu, instances
  `CursorMenu`, hands it the target + that object's action list, parents it
  under `UIController`, and connects `action_chosen` (with `world_position`
  bound on). On a choice it `match`es the action `id` and commands the Ship.
- **CursorMenu self-composes.** Given an action array it builds its own buttons
  in `_ready`, each `.bind(id)`. It holds its `target` (handed in at instance
  time, never re-looked-up → can't desync if you click elsewhere first).
- **UIController owns the HUD.** It follows the ship by converting the ship's
  world position to screen space every frame:
  `player_ship.get_global_transform_with_canvas().origin`. A CanvasLayer is
  screen-space, so you must convert world→screen — you can't feed it world
  coords directly.

---

## Key systems

### Ship movement (`Ship/Ship.gd`)
Two modes, switched by `is_orbiting`:

- **`move_to_target` (turn-then-move):** rotate toward the target with
  `rotate_toward(rotation, angle, turn_speed*delta)` (clamped — no overshoot).
  Only once aligned (within `rotation_epsilon`) does it step forward by
  `min(speed*delta, remaining)` so it lands *exactly* on the point instead of
  jittering past it.
- **`orbit_target` (pursuit curve):** advance a phantom `orbital_angle`, place
  `target_position` on the orbit circle, and chase it. Facing follows the
  *velocity* (where it's heading), not the orbit center — that's what makes the
  drag-into-orbit S-bend look smooth.
- **`set_orbit`** picks spin direction with a cross product:
  `signf((position - orbit_center).cross(heading))` — orbit the way the nose is
  already pointing, so entry doesn't snap backward.

The ship writes `position`/`rotation` into `GameState` as it moves, and restores
them in `_ready`, so pose survives a scene reload.

### State retention across reset
`reload_current_scene` rebuilds everything from scratch. To keep continuity,
`System.system_reset(rotation, position, zoom, cargo)` stuffs those into
`GameState` *before* the deferred reload; Ship, SystemCamera, and the cargo HUD
each read their slice back in `_ready`.

### Debug trail
`Ship` drops a breadcrumb every `TRAIL_GAP` world-units (capped at `TRAIL_MAX`)
and draws a polyline + dots in `_draw`. Two things were load-bearing: you must
call `queue_redraw()` to make `_draw` fire, and world points get mapped through
`to_local()` because `_draw` is in the ship's moving/rotating frame. Gated on
`GameState.debug`.

---

## Hard-won lessons (bug families to watch for)

- **Turn-then-move deadlock:** never gate the *producer* behind what it
  produces. If rotation only runs once aligned, it never aligns. One phase = one
  job; keep rotation outside the alignment gate.
- **Chase can lose a race:** `rotate_toward` is a chase. If the target's angle
  changes faster than `turn_speed`, facing falls behind / flips. `turn_speed`
  must exceed the orbit's angular rate.
- **Float `==` is a trap** — compare with an epsilon.
- **Computed-but-not-applied** — `x = f(x)`, not just `f(x)`.
- **Wrong-time computation** — a value derived once at member-init is stale by
  the next frame; derive per-frame what changes per-frame. (The orbit-seed bug:
  seeding from a stale `target_position` instead of live `position`.)
- **Zero-vector degeneracy** — `atan2(0,0)=0`, `Vector2.ZERO.normalized()` is
  garbage. Guard the radial / coincident case.
- **Coordinate space** — world vs screen are different origins (~half a screen
  apart under zoom + a moved camera). CanvasLayer = screen space; convert.
- **Draw order** — `Node2D._draw` renders *below* children; occluders need
  `show_behind_parent`.

---

## Parking lot (known, deliberately deferred)

- **Orbit teardrop loop** on a dead-radial approach (cross product ≈ 0 → no
  clear spin direction). Declared "a dead rabbit" for now — acceptable.
- **Dead code to sweep when convenient:** `_on_ship_position_changed` in
  `System.gd` (its signal was deleted), the redundant `if/else` then overwrite
  in `Ship._ready`, the commented-out `OrbitPhase` state-machine in `Ship.gd`,
  and stray dev `print()`s. None of it breaks anything; it's just clutter.
- **`TRAIL_MAX`** has been pushed high during debugging — heavy if left large.

---

## Workflow notes
- Cody develops on `main`. For this CLAUDE.md to auto-load it needs to live on
  the branch he actually runs.
- He writes the code and pastes it back for review — expect to read diffs, not
  author files.
- Sign-offs like "tomorrow!" / "huzzah feelsgoodman" = session end, work landed.
