extends Control
class_name VirtualJoystick

## Virtual joystick for touch-based movement.
## Drag from center to move in any direction.

signal joystick_moved(vector: Vector2)

@export var dead_zone: float = 10.0
@export var max_radius: float = 50.0
@export var joystick_color: Color = Color(1.0, 1.0, 1.0, 0.6)
@export var knob_color: Color = Color(1.0, 1.0, 1.0, 0.8)

var _active: bool = false
var _stick_pos: Vector2 = Vector2.ZERO
var _touch_index: int = -1

@onready var _base: Panel = $Base
@onready var _knob: Panel = $Knob

func _ready():
	_base.modulate = joystick_color
	_knob.modulate = knob_color
	_knob.position = _base.size / 2 - _knob.size / 2
	joystick_moved.connect(_on_joystick_moved)

func _on_joystick_moved(vector: Vector2) -> void:
	Global.update_joystick_input(vector)

func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		var local_pos = event.position - global_position

		# Touch started inside joystick area
		if event.pressed and _touch_index == -1:
			var center = _base.size / 2
			var dist = local_pos.distance_to(center)
			var base_radius = min(_base.size.x, _base.size.y) / 2
			if dist <= base_radius * 1.5:
				_active = true
				_touch_index = event.index
				_update_knob(local_pos)
				emit_signal("joystick_moved", _get_input_vector())
				return

		# Touch released
		if not event.pressed and event.index == _touch_index:
			_active = false
			_touch_index = -1
			_reset_knob()
			emit_signal("joystick_moved", Vector2.ZERO)
			return

	# Touch dragged
	if event is InputEventScreenDrag and event.index == _touch_index and _active:
		var local_pos = event.position - global_position
		_update_knob(local_pos)
		emit_signal("joystick_moved", _get_input_vector())

func _update_knob(touch_pos: Vector2) -> void:
	var center = _base.size / 2
	var offset = touch_pos - center
	var dist = offset.length()
	var max_r = min(_base.size.x, _base.size.y) / 2 - _knob.size.x / 2

	if dist > max_r:
		offset = offset.normalized() * max_r
		_knob.position = center - _knob.size / 2 + offset
	else:
		_knob.position = center - _knob.size / 2 + offset

func _reset_knob() -> void:
	_knob.position = _base.size / 2 - _knob.size / 2

func _get_input_vector() -> Vector2:
	var center = _base.size / 2
	var knob_center = _knob.position + _knob.size / 2
	var offset = knob_center - center
	var dist = offset.length()

	if dist < dead_zone:
		return Vector2.ZERO

	var direction = offset.normalized()
	var magnitude = (dist - dead_zone) / (min(_base.size.x, _base.size.y) / 2 - dead_zone)
	magnitude = clamp(magnitude, 0.0, 1.0)
	return direction * magnitude
