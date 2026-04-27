# Story ct-004: 剑气斩 — Melee AOE

> **Epic**: Combat | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Press skill button → forward fan-shaped attack area appears
- [ ] Deals 30 damage to all enemies in area
- [ ] Cooldown: 5 seconds
- [ ] Player cannot move during attack animation (0.3s)
- [ ] Visual: sword slash effect in front of player

## QA Test Cases

- **TC-1**: 2 enemies in range → both take 30 damage
- **TC-2**: Skill used → cooldown timer visible in HUD
- **TC-3**: Cooldown not finished → button disabled
