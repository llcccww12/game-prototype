# Story ui-003: Damage Numbers and Effects

> **Epic**: HUD | **Status**: Ready | **Type**: Logic | **Layer**: Polish

## Acceptance Criteria

- [ ] Damage number floats up from hit enemy, fades out over 0.5s
- [ ] Screen shake on player taking damage (intensity: 5px, duration: 0.2s)
- [ ] Red overlay flash on player taking damage (opacity: 20%, duration: 0.1s)
- [ ] Player invincibility flash (blink) when taking damage with i-frames

## QA Test Cases

- **TC-1**: Enemy hit by player → damage number appears above enemy
- **TC-2**: Player hit → screen shakes, red flash
- **TC-3**: Damage number fades out completely after 0.5s
