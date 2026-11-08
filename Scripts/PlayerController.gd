extends CharacterBody2D


@export var move_speed: float = 180.0
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var sprite_2d: Sprite2D = $WeaponPivot/Sprite2D

@export var dash_speed: float = 520.0
@export var dash_duration: float = 0.14

var _is_dashing := false
var _dash_timer := 0.0
var _dash_dir := Vector2.RIGHT

func _physics_process(delta: float) -> void:
	_update_aim()
	_update_dash(delta)
	
	if _is_dashing:
		velocity = _dash_dir * dash_speed
	else:
		velocity = _get_move_input() * move_speed
	
	move_and_slide()

func _get_move_input() -> Vector2:
	var v := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return v.normalized() if v.length() > 1.0 else v

func _update_aim() -> void:
	var to_mouse := get_global_mouse_position() - global_position
	weapon_pivot.rotation = to_mouse.angle()
	if absf(to_mouse.x) > 4.0:
		sprite_2d.flip_h = to_mouse.x < 0.0

func _start_dash() -> void:
	var input := _get_move_input()
	if input.length() > 0.1:
		_dash_dir = input.normalized()
	else:
		var to_mouse := get_global_mouse_position() - global_position
		_dash_dir = to_mouse.normalized() if to_mouse.length() > 0.01 else Vector2.RIGHT
	_is_dashing = true
	_dash_timer = dash_duration
	
func _end_dash() -> void:
	_is_dashing = false

func _update_dash(delta: float) -> void:
	if _is_dashing:
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			_end_dash()
		return
	if Input.is_action_just_pressed("dash"):
		_start_dash()
