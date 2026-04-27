# Story ui-001: HUD — Health and Stamina Bars

> **Epic**: HUD | **Status**: Ready | **Type**: Logic | **Layer**: Presentation

## Acceptance Criteria

- [ ] Health bar: top of screen, shows current/max HP as filled bar
- [ ] Health bar color: green (>50%) → yellow (25-50%) → red (<25%)
- [ ] Stamina bar: below health bar, blue fill
- [ ] Room progress: 4 dots (filled = completed, hollow = remaining)
- [ ] Passive icons: bottom-right, 3 slots showing active passives

## QA Test Cases

- **TC-1**: HP drops to 40% → bar turns yellow
- **TC-2**: HP drops to 20% → bar turns red
- **TC-3**: 3 passives collected → all 3 icons visible in HUD
