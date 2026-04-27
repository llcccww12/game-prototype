# Story ct-005: 飞燕回翔 — Dash Attack

> **Epic**: Combat | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Dash forward 150px, passes through enemies
- [ ] Deals 15 damage to enemies passed through
- [ ] Grants i-frames during dash (0.3s)
- [ ] Cooldown: 4 seconds
- [ ] If no movement direction, dash forward

## QA Test Cases

- **TC-1**: Dash through 3 enemies → all take 15 damage, player takes none
- **TC-2**: Dash into wall → stops at wall, no clip through
