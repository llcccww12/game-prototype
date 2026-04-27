# Epic: Player Core

**Status**: Ready
**Layer**: Foundation
**Systems**: Input System, Game State Machine, Player Stats, Room Manager

## Overview

Foundation systems that everything else depends on. Player movement, touch input, basic stats, and room structure.

## GDD Requirements

- Player Stats: `design/gdd/systems-index.md` (TR-PLY-001)
- Input: `design/gdd/systems-index.md` (TR-PLY-002)
- Room: `design/gdd/systems-index.md` (TR-ROOM-001)

## Stories

| # | Story | Type | Status |
|---|-------|------|--------|
| 001 | Player movement with virtual joystick | Logic | Ready |
| 002 | Game state machine (menu/playing/dead/win) | Logic | Ready |
| 003 | Player HP and stamina stats | Logic | Ready |
| 004 | Room manager with 4-room layout | Integration | Ready |
