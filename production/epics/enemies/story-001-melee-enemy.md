# Story em-001: Melee Enemy AI

> **Epic**: Enemies | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Chases player at speed 80px/s
- [ ] Contact with player deals 20 damage (1s cooldown)
- [ ] HP: 30 (dies in 2 player hits)
- [ ] On death: plays death animation, removed from scene
- [ ] Spawns at room entrance

## QA Test Cases

- **TC-1**: 2 hits from player → enemy dies
- **TC-2**: Enemy touches player → player takes 20 damage
- **TC-3**: Enemy cannot be hit during death animation
