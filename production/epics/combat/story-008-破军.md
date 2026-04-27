# Story ct-008: 破军 — Screen Nuke

> **Epic**: Combat | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Hold button to charge (0.8s), release to trigger
- [ ] Deals 50 damage to ALL enemies on screen
- [ ] Player is invulnerable during charge
- [ ] Long cooldown: 15 seconds
- [ ] Visual: expanding ring effect from player

## QA Test Cases

- **TC-1**: 3 enemies on screen → all take 50 damage
- **TC-2**: Released at 0.3s → charge cancelled, no damage, no cooldown
- **TC-3**: