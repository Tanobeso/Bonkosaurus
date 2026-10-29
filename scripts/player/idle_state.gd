extends NodeState

@export var player: CharacterBody2D

func _on_physics_process(delta: float) -> void:
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.friction * delta)
	player.handle_tail_rotation()
	player.move_and_slide()

func _on_next_transitions() -> void:
	if GameInputEvents.is_attacking():
		transition.emit("ChargeState")
	elif GameInputEvents.is_movement_input():
		transition.emit("WalkingState")
