# Story pc-004: Room Manager

> **Epic**: Player Core | **Status**: Ready | **Type**: Integration | **Layer**: Foundation

## Context

**GDD**: `design/gdd/systems-index.md`
**Engine**: Godot 4.6 | **Risk**: MEDIUM

## Acceptance Criteria

- [ ] Generates 3 random normal rooms + 1 Boss room
- [ ] Room order is random
- [ ] Entering room triggers enemy spawn
- [ ] Clearing all enemies in room opens exit to next room
- [ ] Boss room is always last (4th)
- [ ] Room progress shown as 4 dots in HUD

## QA Test Cases

- **TC-1**: 3 runs produce different room orders (random seed)
- **TC-2**: All enemies killed → exit opens (door/signal)
- **TC-3**: Entering Boss room triggers Boss spawn
