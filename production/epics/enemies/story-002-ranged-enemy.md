# Story em-002: Ranged Enemy AI

> **Epic**: Enemies | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Tries to maintain distance from player (150px)
- [ ] Fires arrow every 2 seconds toward player position
- [ ] Arrow: 15 damage, 300px/s speed
- [ ] HP: 20 (dies in 1 player hit)
- [ ] If player gets too close, retreats

## QA Test Cases

- **TC-1**: 1 player hit → ranged enemy dies
- **TC-2**: Arrow hits player → 15 damage applied
- **TC-3**: Player within 100px → enemy retreats
