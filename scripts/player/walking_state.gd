extends NodeState

@export var player: CharacterBody2D

func _on_physics_process(delta: float) -> void:
	var input_dir: Vector2 = GameInputEvents.movement_input()

	if input_dir != Vector2.ZERO:
		player.velocity = player.velocity.move_toward(input_dir * player.max_speed, player.acceleration * delta)
		
		var target_angle: float = input_dir.angle()
		player.rotation = lerp_angle(player.rotation, target_angle, player.rotation_speed * delta)
	
	player.handle_tail_rotation()
	player.move_and_slide()

func _on_next_transitions() -> void:
	if GameInputEvents.is_attacking():
		transition.emit("Charge")
	elif !GameInputEvents.is_movement_input() and player.velocity.length() < 10.0:
		transition.emit("Idle")
