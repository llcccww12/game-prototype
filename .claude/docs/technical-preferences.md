# Technical Preferences

<!-- Populated by /setup-engine. Updated as the user makes decisions throughout development. -->

## Engine & Language

- **Engine**: Godot 4.6
- **Language**: GDScript
- **Rendering**: GL Compatibility (mobile-friendly)
- **Physics**: Godot Physics (default)

## Input & Platform

- **Target Platforms**: Android, iOS
- **Input Methods**: Touch (primary), Virtual Joystick
- **Primary Input**: Touch / Virtual Joystick
- **Gamepad Support**: None
- **Touch Support**: Full
- **Platform Notes**: All UI must support touch tap. No hover-only interactions. Virtual joystick bottom-left. Skill buttons bottom-right.

## Naming Conventions

- **Classes**: PascalCase (e.g., `PlayerController`)
- **Variables**: snake_case (e.g., `move_speed`)
- **Signals**: snake_case past tense (e.g., `health_changed`)
- **Files**: snake_case matching class (e.g., `player_controller.gd`)
- **Scenes**: PascalCase matching root node (e.g., `PlayerController.tscn`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_HEALTH`)

## Performance Budgets

- **Target Framerate**: 60 FPS
- **Frame Budget**: 16.6ms
- **Draw Calls**: [TO BE CONFIGURED — test on target device]
- **Memory Ceiling**: 512MB (mobile budget)

## Testing

- **Framework**: GUT (Godot Unit Test)
- **Minimum Coverage**: [TO BE CONFIGURED]
- **Required Tests**: Balance formulas, combat formulas, room generation

## Forbidden Patterns

- [None configured yet — add as architectural decisions are made]

## Allowed Libraries / Addons

- [None configured yet — add as dependencies are approved]

## Architecture Decisions Log

- [No ADRs yet — use /architecture-decision to create one]

## Engine Specialists

- **Primary**: godot-specialist
- **Language/Code Specialist**: godot-gdscript-specialist (all .gd files)
- **Shader Specialist**: godot-shader-specialist (.gdshader files)
- **UI Specialist**: godot-specialist (no dedicated UI specialist — primary covers all UI)
- **Additional Specialists**: godot-gdextension-specialist (native plugins only)
- **Routing Notes**: Primary for architecture and cross-cutting review. GDScript specialist for code quality and idioms.

### File Extension Routing

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| Game code (.gd files) | godot-gdscript-specialist |
| Shader / material files (.gdshader) | godot-shader-specialist |
| UI / screen files (Control nodes) | godot-specialist |
| Scene / level files (.tscn, .tres) | godot-specialist |
| Native extension / plugin files (.gdextension) | godot-gdextension-specialist |
| General architecture review | godot-specialist |
