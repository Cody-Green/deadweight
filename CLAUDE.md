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
   trying to learn is the failure mode. Pseudocode of a standard idiom is OK
   when he's genuinely stuck (the flag pattern, the pulse accumulator).
4. **API trivia is free.** Function names, signatures, "does this built-in
   exist" — hand those over immediately (`is_instance_valid`, `TAU`,
   `distance_to`, `assert(cond, msg)`). Recognizing *which* tool to reach for
   is the skill being trained; memorizing the identifier is not.
5. **Rescue mode when genuinely stuck.** If he's frustrated, tired, or circling
   the same wall, drop the Socratic stance and spell it out. "Explain like I'm
   12," "lost in the sauce," "I must be tired" are the signals.

### Who Cody is (calibrate explanations to this)
- ~30 years casual / self-taught coding. Strong intuition, real shipping sense.
- Formal math tops out around grade 9. Define the math when it shows up.
- Gaps in formal CS/DSA vocabulary — **define jargon** (shadowing, short-circuit,
  rejection sampling, static vs dynamic typing, boxing) rather than assuming it.
- `return` vs `break` vs `continue` confusion has bitten three times — watch it.
- Dislikes ambiguity; wants the *why*, not just the *what*.
- Spatial / geometric thinker — worked numeric examples and diagrams land well.
- **Run before you push** is a habit still being installed. Ask "did you run it?"

### Review workflow
- Cody develops on `main` and pushes; Claude pulls and reviews (Claude's git
  access is read-only — a 403 blocks push; deliberate fallback: Claude hands
  files/content in chat, Cody commits them himself).
- Reviews: credit what's right first, then bugs in severity order, then
  housekeeping. End with the next concrete step and required tests.

---

## The project

**DEADWEIGHT** — single-player, offline, 2D top-down extraction-sandbox space
game. **Godot 4.6, GDScript.** Fly a ship, click objects for a context menu,
mine asteroids, collect mass.

- `README.md` is the GDD. A rewrite pass (terse, hashtag-style, no
  self-justification) got through §0–§5 in-chat but was parked for code work —
  current file is still the old long-form v0.13. Do not treat its specifics as
  locked design.
- `GameState/GameState.gd` is the only autoload.
- Main scene: `System/System.tscn`.
- Current MVP target (mockup: `ideas and references/Mining_Mockup.svg`):
  asteroid fields ✓, mining ✓, tractor beam (pending), pinned contacts panel
  with pop-out menus (pending), station to close the cargo loop (pending).

---

## Architecture spine

Decoupling by responsibility. Delegate in code; organize the scene tree by what
nodes *are*.

```
System (Node2D)            ← coordinator / router. Menu lifecycle, wiring. Routes only.
├── SystemCamera (Camera2D)← pan (WASD poll), zoom, recenter. Self-restores from GameState.
├── InputManager (Node2D)  ← the ONLY node that reads hardware input. Emits signals.
├── AsteroidSpawner        ← seeds N fields of M asteroids, rejection-sampled spacing.
├── UIController (CanvasLayer) ← owns all screen-space HUD. Immune to camera.
│   └── ShipCargoLabel
├── Grid / GridBackground  ← show_behind_parent so the debug trail isn't occluded.
├── EmptySpace (Node)      ← data: menu actions for empty-space clicks.
└── Ship (Node2D)          ← movement + mining beam. Writes pose to GameState.
    (Asteroids and ore-chunk Collectibles spawn in as System children at runtime.)
```

- **InputManager** point-queries layer 3 "clickable" (`collision_mask = 0b100`),
  emits `target_selected(object, world_pos, screen_pos)`.
- **Objects own their data and menu**: `get_menu_actions()` on Asteroid
  (Approach/Mine/Orbit), Collectible, EmptySpace (Move To).
- **System routes**: `match` on action id → commands the Ship. Game rules do
  NOT live here (the mining range check was deliberately moved out).
- **CursorMenu self-composes** from the action array; holds its `target`.
- **Collision layers**: layer 1 = physical, layer 3 = clickable. Scene file
  owns the values; `CollisionArea.gd` scripts hold `assert`s that *verify*
  (never write) them — one source of truth plus a debug-build tripwire.

## Key systems

### Asteroids (`Asteroid/Asteroid.gd`)
- **Shape**: radial polygon — walk `TAU/resolution` steps, vertex =
  `Vector2(cos(a), sin(a)) * randf_range(min_r, max_r)`, centered on ZERO
  (local space!). Same vertices feed `$AsteroidShape.polygon` (visual) and
  `$CollisionArea/CollisionShape.polygon` (clickable) — one source of truth.
- **Ore**: `ore_mass` pool rolled at `_ready`. `extract_ore_chunk()`:
  `chunk_mass = min(roll, ore_mass)` used for BOTH the subtraction and the
  chunk — mass is conserved exactly (100-mass rock = 400 kg cargo… per 4 rocks).
  Chunk = a spawned `Collectible` (mass set before `add_child`), parented to
  the asteroid's parent (System) so it outlives the rock. Dry rock →
  `queue_free()`.
- Shape/ore params currently live in GameState (config-in-the-state-drawer
  smell — see parking lot: Resource refactor).

### Field spawning (`Spawners/AsteroidSpawner.gd`)
Rejection sampling: roll a candidate `Vector2`, flag-pattern check against all
accepted positions (`min spacing = asteroid_max_radius * 2 * (1.0 + buffer)`),
retry up to `max_rolls`, skip the slot on cap-out (escape hatch — a too-dense
config underfills instead of hanging). Positions decided before rocks exist,
so spacing uses the worst-case radius.

### Mining (ship = beam, rock = ore)
- `initiate_mining(target)`: stores `mining_target`, sets `is_mining`; if out
  of range, also sets course to `mining_range - 5`. Re-clicking retargets.
- `_process` gate, three honest states: dead target → `is_mining = false`
  (job over); in range → accumulate `delta`, pulse every `mining_laser_cycle`
  seconds (job running); otherwise nothing (job paused — beam winks off, does
  NOT cancel; range gates the beam, only death/new-command end the job).
- `mining_pulse()` = just `mining_target.extract_ore_chunk()`; all guarding
  upstream. Guard order matters: `is_instance_valid` BEFORE any dereference.
- Chunks currently spawn at the ship (insta-collect, commented `#Temporary`)
  until the tractor beam exists.

### Ship movement (`Ship/Ship.gd`)
- `move_to_target`: turn-then-move; rotate with `rotate_toward` (clamped),
  step `min(speed*delta, remaining)` once aligned.
- `orbit_target`: pursuit curve — advance phantom `orbital_angle`, chase the
  circle point, face velocity. `set_orbit` picks spin via cross product.
- Orbit's future customers: mining posture, salvage (GDD §5), combat
  transversal. It is load-bearing, not a novelty.
- Hull + collision triangle both derive from `hull_width / 2` at the call
  site in `_ready` (visual/collision can't drift).
- Pose written to GameState each move; restored in `_ready` (survives reset).

### State retention across reset
`System.system_reset(...)` stuffs rotation/position/zoom/cargo into GameState
before the deferred `reload_current_scene`; Ship, SystemCamera, cargo HUD each
read their slice back in `_ready`.

### Debug trail
Breadcrumb every `TRAIL_GAP`, capped `TRAIL_MAX` (currently 2000 — hot, dial
down when done debugging), polyline in `_draw` via `to_local()`, needs
`queue_redraw()`. Gated on `GameState.debug`.

---

## Hard-won lessons (bug families — the list grows)

- **The identity round-trip:** `v.normalized() * v.length()` == `v`; decomposing
  a vector into angle/length and rebuilding it changes nothing. Three
  appearances. The tell: `.normalized() * something.length()`.
- **Point vs displacement:** subtracting two positions gives an *arrow*, not a
  place. Spawn positions need `anchor + direction * distance` — all three slots.
- **Coordinate space (the nemesis, 4+ hits):** polygon/vertex coords are ink on
  the node's own paper; `position` is where the parent glued the paper. Never
  add `position` into local geometry. World↔screen: CanvasLayer needs
  `get_global_transform_with_canvas()`.
- **Shadowing:** `var x = ...` inside a function creates a NEW local even if a
  member `x` exists — the member stays zero forever. Assignment ≠ declaration.
- **`while` in `_process` freezes the game:** `_process` IS one turn of the
  engine's loop; a `while` that waits on game state never returns the turn, so
  movement/physics/queue_free never run and the condition can never change.
- **`return` vs `break` vs `continue` (3 hits):** return exits the whole
  function (and `_process` is shared real estate — a subsystem block may not
  end everyone's frame); break exits one loop; continue skips one iteration.
- **null ≠ freed:** a `queue_free`d object is NOT null; `if not x` misses it.
  `is_instance_valid(x)` answers both. Guard before dereference; short-circuit
  `and`/`or` makes the one-liner safe.
- **Stale state flags lie:** a flag only honest if every exit path resets it.
  If the gate that would reset it can't fire (unreachable code), the flag
  outlives its truth. Dead guards are worse than deleted ones.
- **Mass ledger:** clamp ONCE into a local, use it on both sides (subtract +
  grant). Round-number test configs (100/25) can't expose imbalance — test
  odd remainders.
- **Two sources of truth drift:** scene property + script both writing the same
  value = the editor value silently loses. One owner; `assert` to verify.
- **Turn-then-move deadlock / chase races / float `==` / computed-but-not-applied
  / wrong-time computation / zero-vector degeneracy / draw order** — see git
  history of Ship.gd; all still apply.
- **Debug habit:** when a dial does nothing, PRINT WHAT THE DIAL COMPUTES.
  When code is pasted without running, ask "did you run it?"

---

## Parking lot (known, deliberately deferred)

- **Tractor beam** (v2 of collection) — then remove the spawn-on-ship hack in
  `extract_ore_chunk` and spawn chunks off the rock instead.
- **Pinned contacts panel** (mockup right side) — list of system contacts with
  pop-out action menus; seed of GDD §14's resolution ladder. Needs asteroids in
  a group (still `#new_asteroid.add_to_group("NAME_OF_GROUP")`).
- **Station + sell/deliver** — closes the collect→spend loop; mockup has
  "Station 1" waiting.
- **Typing pass** — `class_name` on Ship/Asteroid/Collectible/CursorMenu, typed
  vars/signatures everywhere. Motivation: editor completion + parse-time errors
  (NOT performance — typed GDScript is tens-of-percent on script hot paths;
  frame time lives in engine C++ anyway).
- **Resource refactor** — asteroid/ore tunables out of GameState into a
  `.tres` (GDD "data-driven"); GameState should hold *state*, not config.
- **Ship.approach_to(pos, standoff) helper** — the "move to within X of
  object" math now exists in 3 copies (approach action, collect action,
  initiate_mining).
- **`set_hull(length, width, ...)`** — `width` param actually receives a
  half-width now; rename when next in the file.
- **Orbit teardrop loop** on dead-radial approach (cross ≈ 0) — still parked.
- **GDD rewrite** — resume at §6 (Component Forge) in the terse style locked
  for §0–§5.
- **CollectibleSpawner.gd** — no longer instanced anywhere; delete or keep as
  reference.

---

## Workflow notes
- Cody develops on `main`; this file must live on `main` to auto-load.
- He writes the code and pushes; Claude pulls, reviews, challenges.
- Claude cannot push (403) — Claude hands file contents in chat, Cody commits.
- Sign-offs like "tomorrow!" / "huzzah" = session end, work landed.
