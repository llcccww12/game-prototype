# Story ui-002: Virtual Joystick

> **Epic**: HUD | **Status**: Ready | **Type**: Logic | **Layer**: Presentation

## Acceptance Criteria

- [ ] Semi-transparent joystick base (60% opacity)
- [ ] Joystick knob follows finger within max radius
- [ ] Knob snaps back to center on release
- [ ] Works with multi-touch (joystick + skill buttons simultaneously)
- [ ] Positioned bottom-left, 20% from screen edge

## QA Test Cases

- **TC-1**: Touch and drag → knob follows finger
- **TC-2**: Release → knob returns to center
- **TC-3**: Skill button + joystick simultaneously → both register
