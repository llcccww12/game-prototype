# Story pc-001: Virtual Joystick Movement

> **Epic**: Player Core | **Status**: Ready | **Type**: Logic | **Layer**: Foundation

## Context

**GDD**: `design/gdd/systems-index.md`
**Requirement**: TR-PLY-002
**Engine**: Godot 4.6 | **Risk**: MEDIUM (touch UX on mobile)

## Acceptance Criteria

- [ ] Virtual joystick appears bottom-left of screen
- [ ] Drag from joystick center to move in 8 directions
- [ ] Movement speed: 200 pixels/second (configurable)
- [ ] Joystick dead zone: 10px from center
- [ ] Max joystick drag radius: 50px
- [ ] Character sprite faces movement direction (flip_h)
- [ ] Works on mobile touch (not just mouse)

## Implementation

Godot 4 + GDScript. Use TouchScreenButton or custom Area2D for joystick.
Input vector normalized for consistent diagonal speed.

## QA Test Cases

- **TC-1**: Given joystick at rest, player does not move
- **TC-2**: Given full joystick drag up, player moves up at 200px/s
- **TC-3**: Given diagonal drag, player moves at same speed as cardinal