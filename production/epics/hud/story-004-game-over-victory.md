# Story ui-004: Game Over and Victory

> **Epic**: HUD | **Status**: Ready | **Type**: Integration | **Layer**: Presentation

## Acceptance Criteria

- [ ] DEATH screen: dark overlay, "你死了" text, "再来一局" button
- [ ] VICTORY screen: warm overlay, "通关成功" text, "再玩一次" button
- [ ] Retry button resets all stats, regenerates rooms
- [ ] Player cannot move during DEAD/VICTORY state

## QA Test Cases

- **TC-1**: Player HP → 0 → death screen appears
- **TC-2**: Boss HP → 0 → victory screen appears
- **TC-3**: Retry pressed → game restarts from fresh state
