# Story ct-002: Dodge with i-frames

> **Epic**: Combat | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Dodge button triggers dash in movement direction
- [ ] Costs 20 stamina per dodge
- [ ] Grants 0.3s invincibility (i-frames)
- [ ] Player is invulnerable to damage during i-frames
- [ ] Dodge cooldown: 0.5s
- [ ] Cannot dodge with stamina < 20

## QA Test Cases

- **TC-1**: Dodge into enemy attack during i-frames → no damage taken
- **TC-2**: Dodge with 15 stamina → rejected, no stamina spent
- **TC-3**: Dodge then immediately try again → 0.5s cooldown respected
