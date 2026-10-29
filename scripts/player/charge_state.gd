extends NodeState

@export var player: CharacterBody2D

var current_charge: float = 0.0

func _on_enter() -> void:
	current_charge = 0.0

func _on_process(delta: float) -> void:
	current_charge = min(current_charge + delta, player.max_charge_time)

func _on_physics_process(delta: float) -> void:
	var input_dir: Vector2 = GameInputEvents.movement_input()
	player.velocity = player.velocity.move_toward(input_dir * (player.max_speed * 0.3), player.acceleration * delta)
	
	player.handle_tail_rotation()
	player.move_and_slide()

func _on_next_transitions() -> void:
	if GameInputEvents.is_attack_just_released():
		player.last_charge_amount = current_charge
		transition.emit("AttackState")
