extends CharacterBody2D


@export var move_speed: float = 180.0


func _physics_process(delta: float) -> void:
	velocity = _get_move_input() * move_speed
	move_and_slide()

func _get_move_input() -> Vector2:
	var v := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return v.normalized() if v.length() > 1.0 else v
