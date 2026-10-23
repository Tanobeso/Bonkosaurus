class_name GameInputEvents

static func movement_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

static func is_movement_input() -> bool:
	return movement_input() != Vector2.ZERO

static func is_attacking() -> bool:
	return Input.is_action_pressed("attack")

static func is_attack_just_released() -> bool:
	return Input.is_action_just_released("attack")
