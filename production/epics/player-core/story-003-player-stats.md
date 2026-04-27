# Story pc-003: Player HP and Stamina

> **Epic**: Player Core | **Status**: Ready | **Type**: Logic | **Layer**: Foundation

## Context

**GDD**: `design/gdd/systems-index.md`
**Engine**: Godot 4.6 | **Risk**: LOW

## Acceptance Criteria

- [ ] Player max HP: 100, starts at 100
- [ ] Player max Stamina: 100, starts at 100
- [ ] Taking damage reduces HP, emits `health_changed` signal
- [ ] HP cannot go below 0 or above max
- [ ] Stamina regenerates 10/second when not dodging
- [ ] Cannot dodge when stamina < 20

## QA Test Cases

- **TC-1**: Damage of 30 → HP reduces from 100 to 70
- **TC-2**: Over