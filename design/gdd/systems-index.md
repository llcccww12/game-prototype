# Systems Index: 霜刃 (Snowblade)

> **Status**: Draft
> **Created**: 2026-04-27
> **Last Updated**: 2026-04-27
> **Source Concept**: design/gdd/game-concept.md
> **Review Mode**: lean (automated, no director gates)

---

## Overview

霜刃 is a 10-15 minute Roguelike action platformer for mobile. The core loop is: enter room → defeat enemies → choose skill/passive → repeat → face Boss. Systems are divided into foundation (no dependencies), core (gameplay mechanics), and presentation (UI/feedback).

MVP scope: 3 rooms + Boss, 5 active skills + 5 passives, 2 enemy types + Boss, touch controls.

---

## Systems Enumeration

| # | System Name | Category | Priority | Status | Design Doc | Depends On |
|---|-------------|----------|----------|--------|------------|------------|
| 1 | Input System | Core | MVP | Not Started | — | — |
| 2 | Game State Machine | Core | MVP | Not Started | — | — |
| 3 | Player Stats (HP/Stamina) | Core | MVP | Not Started | — | — |
| 4 | Room Manager | Core | MVP | Not Started | — | — |
| 5 | Combat System | Gameplay | MVP | Not Started | — | Input, Player Stats |
| 6 | Enemy AI | Gameplay | MVP | Not Started | — | Combat, Player Stats |
| 7 | Active Skill System | Gameplay | MVP | Not Started | — | Combat, Player Stats |
| 8 | Passive System | Gameplay | MVP | Not Started | — | Player Stats |
| 9 | Stamina System | Gameplay | MVP | Not Started | — | Player Stats, Input |
| 10 | Boss System | Gameplay | MVP | Not Started | — | Enemy AI, Combat |
| 11 | Skill Selection UI | UI | MVP | Not Started | — | Active Skill System |
| 12 | HUD System | UI | MVP | Not Started | — | Player Stats, Room Manager |
| 13 | Virtual Joystick | UI | MVP | Not Started | — | Input System |
| 14 | Damage Numbers (inferred) | Polish | MVP | Not Started | — | Combat |
| 15 | Screen Effects (inferred) | Polish | MVP | Not Started | — | Combat, Boss System |

---

## Categories

| Category | Description | Systems |
|----------|-------------|---------|
| **Core** | Foundation systems everything depends on | Input System, Game State Machine, Player Stats, Room Manager |
| **Gameplay** | The systems that make the game fun | Combat, Enemy AI, Active Skill, Passive, Stamina, Boss |
| **UI** | Player-facing information displays | HUD, Skill Selection UI, Virtual Joystick |
| **Polish** | Feedback and juice systems | Damage Numbers, Screen Effects |

---

## Priority Tiers

| Tier | Definition | Target Milestone | Systems |
|------|------------|------------------|---------|
| **MVP** | Required for core loop to function | First playable prototype | All 15 systems |
| **Vertical Slice** | Polished demo experience | Vertical slice / demo | (same in lean MVP) |
| **Alpha** | Full scope, placeholder content OK | Alpha milestone | (future expansion) |
| **Full Vision** | Polish, edge cases, content | Beta / Release | (future: unlocks, multiple difficulties) |

---

## Dependency Map

### Foundation Layer (no dependencies)

1. **Input System** — raw touch/virtual joystick input, feeds all player actions
2. **Game State Machine** — menu/playing/dead/win states, controls what systems are active
3. **Player Stats** — HP and Stamina values, base values for all systems

### Core Layer (depends on foundation)

4. **Room Manager** — generates/loads room layouts, controls room progression
5. **Combat System** — damage calculation, hit detection, attack state machine
6. **Stamina System** — dodge cost and regen, consumed by dodge actions
7. **Active Skill System** — 5 skills (剑气斩/飞燕回翔/冰魄掌/御风步/破军), cooldown, effect application
8. **Passive System** — 5 passives (血战/铁壁/连斩/吸血/疾风), stat modifications
9. **Enemy AI** — simple chase/attack patterns for 2 enemy types
10. **Boss System** — multi-phase Boss with unique attack patterns

### Presentation Layer (depends on core)

11. **HUD System** — health bar, stamina bar, room progress, passive icons
12. **Skill Selection UI** — post-room modal, 3 choices, skill/passive selection
13. **Virtual Joystick** — touch drag area bottom-left, feeds Input System

### Polish Layer

14. **Damage Numbers** — floating damage text, hit feedback
15. **Screen Effects** — screen shake on hit, flash on damage taken

---

## Recommended Design Order

| Order | System | Priority | Layer | Est. Effort |
|-------|--------|----------|-------|-------------|
| 1 | Input System | MVP | Foundation | S |
| 2 | Game State Machine | MVP | Foundation | S |
| 3 | Player Stats | MVP | Foundation | S |
| 4 | Room Manager | MVP | Foundation | M |
| 5 | Combat System | MVP | Core | M |
| 6 | Stamina System | MVP | Core | S |
| 7 | Active Skill System | MVP | Core | M |
| 8 | Passive System | MVP | Core | S |
| 9 | Enemy AI | MVP | Core | M |
| 10 | Boss System | MVP | Core | M |
| 11 | HUD System | MVP | Presentation | S |
| 12 | Skill Selection UI | MVP | Presentation | S |
| 13 | Virtual Joystick | MVP | Presentation | S |
| 14 | Damage Numbers | MVP | Polish | S |
| 15 | Screen Effects | MVP | Polish | S |

---

## Circular Dependencies

- None found

---

## High-Risk Systems

| System | Risk Type | Risk Description | Mitigation |
|--------|-----------|-----------------|------------|
| Active Skill System | Design | 5 skills with different effects need balanced cooldowns and damage | Prototype early, tune numbers conservatively |
| Boss System | Technical | Single Boss with multiple attack patterns, tight implementation | Implement simple single-phase first, expand later |
| Virtual Joystick | Technical | Mobile touch UX must feel responsive | Test on actual device early, prototype first |
| Room Manager | Design | Random room generation with enemy placement balance | Use fixed room templates with random enemy spawns (MVP) |

---

## Progress Tracker

| Metric | Count |
|--------|-------|
| Total systems identified | 15 |
| Design docs started | 0 |
| Design docs reviewed | 0 |
| Design docs approved | 0 |
| MVP systems designed | 0/15 |

---

## Next Steps

- [ ] Run `/design-system` for each system in design order
- [ ] Run `/create-architecture` after core systems are designed
- [ ] Run `/prototype combat` to validate the 30-second loop first
- [ ] Run `/gate-check pre-production` when MVP systems are designed
