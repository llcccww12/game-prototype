# Story ct-001: Three-Hit Combo Attack

> **Epic**: Combat | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Tap attack button → hit 1 (damage 20, knockback)
- [ ] Tap within 0.4s → hit 2 (damage 25, knockback)
- [ ] Tap within 0.4s → hit 3 (damage 30, larger knockback)
- [ ] After hit 3 or >0.4s gap → combo resets
- [ ] Each hit plays different animation frame
- [ ] Cannot attack while dodge is active

## QA Test Cases

- **TC-1**: 3 rapid taps → all 3 hits register with increasing damage
- **TC-2**: 0.5s gap after hit 2 → next tap starts new combo at hit 1
- **TC-3**: Attack during dodge → ignored
