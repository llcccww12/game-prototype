# Story ct-003: Stamina Regeneration

> **Epic**: Combat | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Stamina regenerates 10/second continuously
- [ ] Regeneration pauses during dodge animation (0.3s)
- [ ] Stamina capped at 100
- [ ] HUD bar reflects current stamina level

## QA Test Cases

- **TC-1**: Stand still 5s → stamina recovers 50
- **TC-2**: Stamina at 95, regen 5s → caps at 100 (not 145)
