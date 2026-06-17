# DEADWEIGHT
## Game Design Document — v0.12
*Single-player offline extraction sandbox for Godot 4.6.3*

> **Revision note (v0.12):** Coherence sweep. Aligned older sections to the locked composition engine (§6) — replaced leftover PoE-affix language in Pillar 3, the §4.4 tier table, and §§11/12/14 with materials-and-rolls terms; corrected Pillar 4's risk curve to Sector Tension; refreshed stale version tags. Light de-pitch only — the design-intent voice is left intact for the later personal-wording pass.

---

## 0. Project Constraints & Philosophy

- **Built for me — shared, not sold (the Walmsley approach).** Made for myself; anyone who plays is a guest, not a customer — owed nothing, no vote on direction. The cost is social, not technical: declining co-option (feature requests, entitlement, meta-chasing, "soften it for reach") without guilt, which is what keeps the design coherent. Downstream: vision over market, depth over accessibility. Two guardrails kept — always-playable, and legible to me.
- **Dimensionality: 2D, locked.** Top-down tactical space. Correct for solo-dev tractability and because the core (range, orbit, align, the extraction scramble) is inherently a 2D game.
- **Governing discipline — always playable.** Every development phase must end in something independently fun to play. Never accumulate half-built systems with no game on top. Vertical slices over horizontal infrastructure.
- **Build data-driven from day one.** Ships, modules, materials, research, tiers, and frontier generation are defined as data (Godot Resources / external files), not hardcoded. This is what keeps content cheap to add over time.
- **Fun, not a chore.** The game should be punishing in a *fun* way, never a grind for grind's sake. Wealth can buy past tedious steps (trading money for time), and an optional satisfying grind exists for those who enjoy it — but no system should *require* drudgery. Every mechanic is tested against this: if it's busywork, it gets QOL, automation, or a buy-past option. **Reconciled with the Walmsley approach:** the 'pain' embraced is the pain of mastery, depth, and consequence — not hollow busywork. Friction in service of depth is welcome; tedium that teaches nothing is still cut. The bar for acceptable friction rises accordingly, and where exactly that line sits is a live design dial.

---

## 1. Vision

**What it is**: A single-player, offline extraction sandbox in deep space. From a safe home station, commit a ship and a hand-built fit to the dark, push as deep into the tiered frontier as you dare, and try to get home with the haul. Death is real — lose the run and you lose the fit and the cargo; insurance returns only the bare hull.

**Influences**: Tarkov (extraction tension, real loss), Path of Exile (solo-self-found loot and craft chase), Eve Online (ship-fitting and flight), Aurora 4X (research depth), No Man's Sky (endless frontier).

**Design Mantra**: *The dark does not care whether you make it home. One more cycle, or can you still get out?*

**The Core Fantasy**: You are not a destined hero or a rising sovereign. You are a salvager-pilot working an indifferent, dangerous frontier, building a personal arsenal one hard-won roll at a time, always weighing greed against survival.

**What this is NOT**:
- A power fantasy where you grow to dominate the galaxy
- An MMO or multiplayer game
- A story-on-rails experience
- A game where loss is cosmetic or easily undone

### 1.1 Title — Deadweight *(locked)*

The title is **Deadweight**. It carries three meanings at once: *deadweight tonnage* is the real shipping term for a vessel's carrying capacity, so it reads as an authentic hauling-world name; colloquially, deadweight is a burden that drags you down — which is literal here, because cargo mass is the encumbrance term in the Sector Tension function (§5), so your haul is the deadweight that slows your escape and can get you killed; and plainly, *dead*. Retired names: Void Sovereign (v0.1, implied dominance) and the working placeholder The Far Dark (which survives only as the in-world name of the deepest tier band, §4.4).

---

## 2. Core Pillars

### Pillar 1 — The Extraction Loop *(the spine)*
Outfit → deploy → venture deeper → extract or die → spend the gains → deploy deeper. Every session is a push-your-luck expedition. The relief of getting home with a full hold, and the gut-punch of losing it all one jump from safety, are the emotional engine of the game.

### Pillar 2 — Meaningful, Unforgiving Loss
Insurance covers the hull only — never the fit, never the cargo. In Solo Self-Found, you cannot buy back a perfect module; you must find or craft another. Loss has real teeth, and that is the point. An opt-in Ironman mode escalates this to full character permadeath.

### Pillar 3 — Deep, Personal Ship Fitting *(the Component Forge)*
A module's stats are *derived from what it is physically made of*, then refined toward an ideal through a mostly deterministic pipeline with one concentrated gamble (full engine in §6). Aurora-style research defines the possibility space (metallurgy); the Starcom-style physical hull grid makes placement a spatial puzzle where a module's material mass and footprint interact with where it sits. Your fit is *yours*, which is exactly why losing it hurts.

### Pillar 4 — Co-Equal Careers, Shared Tension
Combat, mining, salvage, hacking, and hauling are all first-class ways to play. Each has its own *exposure mechanic* (see §5) but feeds the same universal extraction loop and the same Sector Tension risk curve (§5). No career is a side activity.

### Pillar 5 — Progressive Quality-of-Life as Meta-Progression
The reward for pushing into riskier content is not just better loot — it is *convenience*. Faster travel, safer logistics, better stash management, more reliable crafting, deeper map intel. QOL unlocks are the carrot that pulls the player to deeper tiers, smoothing the whole loop as you grow. This is the loose authored "spine": a progression of capabilities, not a story on rails.

### Pillar 6 — A Living, Tiered Frontier
A safe handcrafted core surrounded by an endless, procedurally generated frontier. Danger and reward scale with depth (tier). The frontier keeps simulating — factions and threats move whether you watch or not — but the structure always gives a clean difficulty/loot gradient.

---

## 3. Risk & Loss Model

### 3.1 What Persists vs. What's At Risk

| Always safe (the Operator) | At risk on a run (the Deployment) |
|---|---|
| Character skills & XP | The deployed ship hull |
| Research progress & blueprints | All fitted modules |
| Home-station stash contents | All cargo (ore, loot, goods) |
| Credits in the bank | Anything looted this run, until extracted |
| Unlocked QOL & vendors | |

### 3.2 Game Modes
- **Standard** (default): Persistent Operator as above. On death you keep the Operator; you lose the deployment. Insurance softens the hull cost. This is the intended "main" experience — hard, but you always rebuild.
- **Ironman / "The Long Dark"** (opt-in at character creation, irreversible): Death wipes the entire character — skills, research, stash, everything. True-stakes mode. Tracked separately (e.g. survival-streak records).

### 3.3 Insurance
- Insurance is a policy on a hull, paid as a premium (per-deployment fee or standing policy).
- It pays out the **bare hull replacement value only** — never modules, never cargo.
- Outcome of a fully insured loss: you respawn at home with the same empty hull and *nothing fitted*. You can fly again immediately, but the grind to re-fit it is the real cost — and that grind is the game.
- Coverage tiers and deductibles are a tuning lever (cheap partial coverage vs. expensive full-hull). Insurance must never feel like it removes the sting.

### 3.4 Death Sequence (Standard)
1. Hull reaches 0 → ship destroyed.
2. Player auto-ejects in an escape pod (always survives in Standard; pods can be destroyed in deep tiers as a future toggle).
3. Pod returns to the nearest safe station (or home).
4. Wreck may drop a recoverable fraction of the fit/cargo — but recovering it means *going back in*, which is its own risk (a future hook).
5. Insurance pays out the hull; the run's gains are gone unless they were extracted before death.

---

## 4. Universe Structure *(finalized v0.3)*

**Model: Hybrid three-band — a static-topology core that opens onto an endless tiered frontier.**

**Static topology, dynamic state.** The map geography is fixed per save (the home you learn and keep), but faction control, markets, and threat density shift underneath it via the background sim. Players must be able to build a durable mental model of safe routes and chokepoints — so the bones never move, only the flesh.

### 4.1 Band 1 — The Sanctuary (handcrafted, always safe)
- A tiny guaranteed-safe pocket (1–3 systems). The "town."
- Holds: home station(s), stash, vendors, market, the Component Forge benches, insurance office, research labs, mission boards.
- Nothing can kill the player here. The fixed return point of the entire loop.

### 4.2 Band 2 — The Settled Frontier (persistent, continuously flyable, tiers 1–7)
- A persistent Eve-style star map: systems connected by stargates, flown continuously (not instanced).
- **Safety is distributed as a tunable field, not a binary.** Each system carries a `SecurityBaseline` value (the floor term in the §5 Sector Tension function). The settled band blends three rules into one curve:
  - **(a) Onboarding ramp** — baseline starts low next to the Sanctuary and rises with depth (the gentle "option 2" start).
  - **(b) Open-space floor** — it climbs to a moderate-to-strong plateau in connective space, so the dark always reads as genuinely dangerous (the "option 3" tone, kept without fully committing).
  - **(c) Safe-hub exceptions** — a handful of systems dip well below the floor; dense near home (waypoints, decompression, economic footholds), thinning out deeper (the "option 1" texture).
- Open-space tension is therefore *logistics through danger*; hubs are deliberate exceptions, not the rule. New-player survivability is handled by (a) + dense near-home hubs without ever making the band feel *safe*.
- **Implementation:** `SecurityBaseline` is per-system data — hand-authored in the inner band, procedural further out as scope requires. The entire distribution is a spreadsheet-level tuning curve, never welded into the map, and can be re-balanced across the project's lifetime with zero architectural change.
- Home to most mining, salvage, and trade activity, and where new players learn the loop before the deep frontier's brutality.
- This band ships first; it is a complete game on its own.

### 4.3 Band 3 — The Deep Frontier (instanced, rolled, tiers 8+)
- Accessed via a **rift** at the edge of settled space. The player rolls/selects a tier and seed, deploys in as a clean instanced raid, and must extract back.
- This is the PoE-atlas layer: it makes "near-infinite" real (endless procedural seeds at escalating tiers) without hand-authoring continuous space, and it gives the extraction loop its cleanest in/out boundary precisely where stakes are highest.
- Added after the settled band is solid; requires no redesign of bands 1–2.

### 4.4 The Tier Gradient (illustrative)
| Tier band | Flavor | Threat | Reward | Where |
|---|---|---|---|---|
| 1–3 | Inner settled | Light | Common ore & materials | Band 2 (flyable) |
| 4–7 | Contested settled | Moderate | Better ore, mid-grade alloys | Band 2 (flyable) |
| 8–12 | Deep rift | Heavy | Rare materials, high rolls | Band 3 (instanced) |
| 13–N | The Far Dark | Brutal | Exotic find-only materials & uniques | Band 3 (instanced) |

> Endgame is sustained high-tier rift expeditions, gated by gear, skills, research, and nerve — not by a final boss or story ending.

---

## 5. Career Exposure Model *(how non-combat careers carry tension)*

**Universal rule:** Extraction = warp out. To warp you must align and be free of warp scramble. Threats carry scramblers; that is the universal extraction-denial mechanic.

**Universal risk accumulator — Sector Tension:** A multi-variable function drives hostile spawn rate and intensity:

> `Tension = SecurityBaseline(sector) × [ 1 + a·timeOnSite + b·heatGenerated + c·(currentMass / emptyMass − 1) ]`

- **SecurityBaseline** — set by the sector's tier/security; deep tiers start hot and ramp fast (`a,b,c` may also scale by tier).
- **timeOnSite** — the alarm clock; lingering raises tension.
- **heatGenerated** — emitted by *loud* actions: mining beams, weapons fire, hacking, active scanning.
- **mass/encumbrance** — a fuller hold both raises detectability *and* slows escape (double jeopardy).

As Tension crosses thresholds, hostile waves escalate; the top of the curve spawns **hunter-elites carrying scramblers** (the extraction-denial moment). Tension resets on successful extraction. This unifies every career under one legible "greed dial."

**Universal trade-off — Encumbrance:** Cargo mass scales align and warp time. A fuller hold is a slower, riskier extraction. The hold is the hostage.

| Career | Exposure mechanic (what makes it risky without seeking combat) |
|---|---|
| **Combat / Bounty** | The fight *is* the exposure — you chose it. Risk = winning the engagement. |
| **Mining** | Beam requires near-stationary operation; full hold adds mass; mining emits a detectable signature that raises tension. *(Variant in §14: deployable drill you defend.)* |
| **Salvage** | Must orbit/tractor wrecks, usually in already-contested battle sites; time-on-site raises heat. |
| **Hacking (Data/Relic)** | Stationary minigame with an alarm timer; failure/slowness summons defenders. |
| **Hauling / Trade** | Heavy, slow hull; valuable cargo increases aggression drawn; gates are ambush chokepoints. |

---

## 6. The Component Forge — composition + refinement engine *(settled v0.7)*

> **Supersedes the earlier PoE-style affix sketch.** Variation does NOT come from random prefix/suffix rolls. A module's power is *derived from what it is physically made of*, then *refined toward an ideal* through a mostly deterministic pipeline with one small, decisive gamble at the end.

### 6.1 Core metaphor — stats are computed, not rolled
A module = a *schematic* (subsystems, each calling for a category of material) + the *materials* filling those subsystems. Each material has physical properties (density, conductivity, thermal tolerance, mass, purity, volatility, resonance…). The module's stats are **functions of its materials' properties** (slug density → damage; coil conductivity → fire rate; coolant tolerance → heat ceiling; total mass → fit/grid cost; purity → reliability). Choosing materials *is* the build. Tradeoffs are inherent physics (denser slug = more damage AND more mass), never bolted-on penalty affixes.

### 6.2 The pipeline (≈75–85% deterministic)
Three stages; each a facility you own, rent, or research-gate, and each bypassable by wealth (buy the output, skip the work — ties to §11's three roads):

1. **Refine & alloy** *(deterministic)* — raw ore → refined materials. Alloying interpolates/blends properties toward a target profile and sets the module's **ideal** (its ceiling). Exotic, high-purity materials exist only in the deep rifts → this is where the **find-only ceiling** lives (apex alloys are found-sourced, scarce, not mass-producible).
2. **Assemble · blueprint** *(deterministic)* — refined materials → component. The blueprint sets the module's intended profile/emphasis; rare **blueprint augments** deterministically reconfigure a recipe (trade one attribute for another). You can reliably reproduce *your design*.
3. **Tune** — see 6.3.

### 6.3 The tune — the gamble (≈15–25%)
The finished component can be **tuned**: each pass pushes an attribute toward perfection but risks degrading another or shaving purity, with risk that *rises the closer to perfect you already are* (Last Epoch–flavoured, against a finite **Integrity** budget). Tuning-augments are *risk tools* (stabilise a pass, target an attribute, seal a perfected one). This is the **only** RNG layer, concentrated here on purpose because it:
- **preserves loss-sting** — your best unit is the one the tune favoured; re-making it means re-running the gauntlet;
- **rhymes with the extraction loop** — "stop at safe-and-good, or push for perfect and risk it" is the rift decision, relocated to the bench.

### 6.4 Why the gamble is concentrated, not spread
RNG sits at one stage, not all three, because multiple RNG layers compound into frustration, a single clear gamble reads as a clean hit-or-stand call, and one stage keeps the 75–85 : 15–25 ratio a controllable dial.

### 6.5 Loss-sting & reproducibility (resolved)
A lost god-roll = re-source exotic materials (6.2 scarcity) **and** re-run the tune gamble (6.3). Both gates intact. The deterministic middle means you reliably rebuild a *good* baseline of your own design, never trivially the *best* unit. Pristine *found* modules can also deliver near-ideal units, bypassing the bench.

### 6.6 Layer ties
- **Hull grid (Starcom):** a module's mass and footprint derive from its materials, so heavier-material builds strain grid placement and fitting — composition and placement interact.
- **Research (Aurora):** unlocks *metallurgy* — assaying materials (perceiving properties/flaws), better refining (higher purity, safer tunes), new alloys and augments. Research expands the possibility space, not affix tiers.
- **Diegetic drops / salvage:** found modules arrive used (carry flaws); salvage reclaims their *materials*. Combat feeds the matter economy.
- **Maintenance (backlog):** modules can re-accrue flaws with use → periodic re-refinement; folds wear into the same purity system.

### 6.7 Open tuning knobs (not blocking)
- Exact deterministic : gamble ratio (target 75–85 : 15–25).
- Whether a *whisper* of instability risk also lives at exotic alloying (6.2), to make exotic matter feel volatile.
- Whether a tiny per-craft "workmanship" variance keeps a sliver of roll-thrill.
- UI legibility for the material-property → stat derivation (the design tax).

---

## 7. Flight, Combat & Activities  `↻ PENDING revision`
*(Carried from v0.1 §5.1/5.4 — to revise under the extraction frame. Key changes coming: warp/align as the extraction action; scrambler as extraction-denial; heat system; per-career exposure mechanics; encumbrance affecting align/warp.)*

Core retained: 2D top-down real-time flight; approach/orbit/align/warp/jump/dock commands; turrets (tracking + falloff), missiles (explosion radius vs signature), drones; shield→armor→hull with damage-type resistances; active modules (hardeners, webs, scramblers, ECM, prop mods).

---

## 8. Ship Classes  `↻ PENDING revision`
*(Carried from v0.1 §5.2 — to revise: class roles reframed around exposure/extraction, e.g. nimble extractors vs. fat-but-rich haulers; align/warp time as a first-class class stat.)*

Frigate / Destroyer / Cruiser / Battlecruiser / Battleship / Industrial, with slot counts and faction bonuses TBD against the new fitting + grid model.

---

## 9. Skills & Progression  `↻ PENDING revision`
*(Carried from v0.1 §5.5 — to revise: integrate with progressive-QOL spine; ensure skills are Operator-persistent; consider how skills gate tier access and reduce extraction risk.)*

XP from kills, extraction success, exploration, manufacturing, trade. Tree categories: Spaceship Command, Gunnery, Missiles, Engineering, Navigation, Trade & Industry, Science, Social.

---

## 10. Factions & Reputation  `↻ PENDING revision`
*(Carried from v0.1 §5.6 — to revise: how factions express in a core+frontier structure; whether standing gates core vendors/insurance, frontier access, or both.)*

Five starting factions (Kessler Compact, Vorn Hegemony, Drift Collective, Sovereignty Fleet, Reclaimer Syndicate); standing −10..+10.

---

## 11. The Module Economy *(settled v0.6)*

The economy is organized around one object — the **module** — seen from three angles. A module is a single kind of thing; it reaches the player's hands by one of three **roads**, and "buying" is not a fourth road but a priced shortcut across the other two.

### 11.1 The three roads
- **Found** — looted from the world. Backbone: **diegetic drops** — hostiles are built from the same module system as the player, so destroying one lets you salvage the modules it actually had fitted (higher-tier enemies carry higher-tier modules, so loot quality scales with danger automatically). Needs a drop/destroy-rate dial (cf. Eve's ~50%) so combat doesn't flood the economy.
- **Forged** — produced through the optional industrial chain: mine raw ore → refine → assemble via blueprints (from research/hacking/salvage/loot) → finished module. Crafting detail lives in §6 (the Forge), including its blueprint- and tuning-augments.
- **Bought** — purchased from the NPC market at a premium, at any step of either road above (buy ore, refined mats, blueprints, augments, or finished modules). Trades money for time; a deliberate money-sink.

### 11.2 The power ceiling (find-only, but per-discipline)
A top band of power — the best materials, the luckiest tune rolls, and unique modules — is **find-only**: earned only from the dangerous deep, never forged or bought. Critically, find-only does **not** mean combat-only. Each discipline reaches its own peak through its own high-risk endgame: the miner works the deadliest deep deposits, the salvager the most dangerous wreck-fields, the hacker the hardest cores, the combat pilot elites and bosses. The peak always demands going into the dark and coming home (preserving the loss-sting), but every lane has its own door in.

This ceiling makes the Bought/Forged roads *safe*: money and the forge carry the player through the entire grindy middle, but skip **chores, not challenges**.

### 11.3 Equity floor + soft specialization
- **Equity floor:** *necessity stays in-lane; incentive crosses lanes.* Nothing the player *needs* ever lives outside their discipline (each lane is self-sufficient to its own peak). Stepping outside your lane is *rewarding, never required.*
- **Soft specialization (locked, vs hard):** each discipline is the *most efficient* source of its signature input — ore (miner), components (salvager), blueprint-augments (hacker), faction bounties/loot (combat) — but **not the only** source. Edges overlap (a fighter grabs loot off kills, a salvager recovers some ore, etc.), so the pure miner stays self-sufficient by either inefficiently gathering secondaries or (cleaner) selling abundant ore and buying the rest — never leaving their activity. Hard specialization (exclusive access) is rejected because, single-player, it would force everything off-lane to come from the NPC sim forever — heavier to build and corrosive to the self-determined-operator fantasy.
- **The cross-pollination dial:** the *size of the efficiency gap* tunes how interdependent the world feels (small gap = independent pillars; large gap = strong temptation to trade/hybridize). Starts **mild-to-moderate** — protecting the "pure miner forever" fantasy is harder to add back later than spice is. Each lane's signature output must be comparably valuable so no discipline becomes a trap.

### 11.4 Single-player economy reality
No other players exist, so every buy/sell is with the **simulated NPC economy** (leans on the background sim for supply/demand and faction production). Money *sources* must be gated behind real play, or "buy power" becomes free and the structure unravels; the spending side (the wealth-bypass) is a healthy sink against inflation. A genuinely combat-exclusive *sliver* of high-value sellable loot and playstyle-shifting exotics is fine as cross-pollination spice — provided every discipline has its own comparable treasure-tier find so no lane is a wealth trap.

---

## 12. Exploration & Research Tree  `↻ PENDING revision`
*(Carried from v0.1 §5.8/5.9 — to revise: scanning/anomalies as primary material and blueprint sources; wormholes as extreme-tier extraction zones; research as the gate on metallurgy per the Forge.)*

Scanning, combat/data/relic sites, wormholes; research tiers T1–T4 with T4 behind deep-frontier exploration.

---

## 13. UI/UX, Audio, Phases, Architecture  `↻ PENDING revision`
*(Carried from v0.1 §6–9 — to revise once the systems above are locked. Notably: HUD must surface heat/alarm, align/warp timer, and the extract decision prominently; Phase 1 should target one core station + one low-tier frontier expedition with the extract-or-die loop end to end.)*

---

## 14. Idea Backlog / Future Considerations *(captured, not yet designed)*

- **Mercenary hiring** — pay NPC wingmen to escort risky runs. They can die, adding their own loss/insurance/logistics layer. Ties into the Social skill line and the economy.
- **ECCM (counter-ECM)** — ECM already exists as a mid-slot module; ECCM as counter-jamming becomes tactically central when breaking a hunter-elite's lock/scramble is the player's escape. Design the ECM↔ECCM↔scramble interplay as the heart of the extraction-denial minigame.
- **Deployable drill + defend** — a mining variant: deploy an autonomous drill platform and defend it while it strips ore. Swaps "sit still yourself" exposure for "defend the asset" tower-defense tension. Generalizable to deployable salvage/harvest platforms.
- **Pod destruction in deep tiers** — optional toggle where escape pods are not guaranteed survival at very high tiers, narrowing the gap between Standard and Ironman in the Far Dark.
- **Wreck recovery runs** — recovering your own lost fit/cargo from a wreck means going back in — a second-order extraction risk.
- **Diegetic drops** *(promoted → §11.1)* — hostiles built from the same module system; salvage what they had fitted.
- **Optional industrial chain** *(promoted → §11.1)* — mine → refine → blueprint → assemble, each step bypassable by wealth.
- **Augments** *(now in §6 Forge)* — blueprint-augments reconfigure a recipe deterministically; tuning-augments are risk tools on the final gamble. Capped by the §11.2 find-only ceiling.
- **Find-only power ceiling** *(promoted → §11.2, now per-discipline)*.

---

## Decisions locked
- Governing principle: **the Walmsley approach** (§0) — built for me and **shared, not sold**; players are guests not customers; cost is social (resisting co-option); depth over accessibility; always-playable and legible to me.
- Title: **Deadweight** (§1.1, locked).
- Genre: single-player offline **extraction sandbox**. **2D, locked.**
- Power arc: **high vulnerability**, no dominance fantasy.
- Loss model: **ship + fit + cargo at risk; hull-only insurance**; optional **Ironman** full permadeath.
- Universe: **hybrid three-band** — Sanctuary (safe) / Settled frontier (persistent, flyable, tiers 1–7) / Deep frontier (instanced rifts, tiers 8+). **Static topology, dynamic state.** Settled-band safety = tunable `SecurityBaseline` field (onboarding ramp → moderate floor → thinning safe hubs).
- Extraction: **warp-out, scrambler-denied**, with **per-career exposure** + **multi-variable Sector Tension** + **encumbrance**.
- Careers: **co-equal** (combat, mining, salvage, hacking, hauling).
- Spine: **progressive QOL** as meta-progression; loose direction, no rails.
- Module economy (§11): **one module, three roads** (Found/Forged/Bought; buying = priced shortcut). **Per-discipline find-only ceiling** (peak earned from each lane's own deep-risk play, not combat-only). **Equity floor** (necessity in-lane, incentive cross-lane). **Soft specialization** (most-efficient not only-source; efficiency gap = cross-pollination dial, start modest). **Fun, not a chore** (§0).
- Component engine (§6): **composition-led** — stats derived from materials; deterministic refine→assemble pipeline (~75–85%) + bounded per-unit **tune** gamble (~15–25%, improve↑/degrade↓, rising risk near perfection); exotics = find-only ceiling. Supersedes the PoE affix sketch.

## Next up in the part-by-part pass
§6 detail — the material-property → stat math model and the tune risk curve (both are simulatable on the sim bench) → then §7 combat (the Aurora "Combat Setup & Mechanics" page is loaded and relevant) → then revisit §8–§13 under the locked frame.
