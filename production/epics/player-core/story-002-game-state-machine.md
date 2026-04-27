# Story pc-002: Game State Machine

> **Epic**: Player Core | **Status**: Ready | **Type**: Logic | **Layer**: Foundation

## Context

**GDD**: `design/gdd/systems-index.md`
**Requirement**: TR-PLY-001
**Engine**: Godot 4.6 | **Risk**: LOW

## Acceptance Criteria

- [ ] States: MENU, PLAYING, PAUSED, DEAD, VICTORY
- [ ] MENU → PLAYING on "Start" button press
- [ ] PLAYING → DEAD when player HP reaches 0
- [ ] PLAYING → VICTORY when Boss HP reaches 0
- [ ] DEAD/VICTORY → MENU on retry/continue press
- [ ] State transitions emit signals for other systems to react

## QA Test Cases

- **TC-1**: HP hits 0 → state changes to DEAD
- **TC-2**: Boss HP hits 0 → state changes to VICTORY
- **TC-3**: Retry button resets all stats and restarts game
