# Story ct-009: Passive Effects

> **Epic**: Combat | **Status**: Ready | **Type**: Logic | **Layer**: Core

## Acceptance Criteria

- [ ] Each passive applies its effect permanently when collected
- [ ] Multiple copies of same passive: effects do NOT stack (per passive type)
- [ ] Max 3 passives at once
- [ ] Passive effects visible in HUD (icon + name)

## Passive Definitions

| Passive | Effect |
|---------|--------|
| 血战 | Damage +20% when HP < 50% |
| 铁壁 | All incoming damage reduced by 10% |
| 连斩 | Attack speed +10% per kill in last 3s (max +30%) |
| 吸血 | Heal 5% of damage dealt |
| 疾风 | Movement speed +15% |

## QA Test Cases

- **TC-1**: Collect 血战, HP at 40% → attack damage increased
- **TC-2**: Collect 3 passives → 4th collection blocked (max 3)
-