extends NodeState

@export var player: CharacterBody2D
@export var tail_hitbox: Area2D
@export var tail_hitbox_shape: CollisionShape2D

var attack_timer: float = 0.0
@export var attack_duration: float = 0.25

var hit_enemies: Array[Node2D] = []

func _on_enter() -> void:
	attack_timer = attack_duration
	hit_enemies.clear()
	if tail_hitbox_shape:
		tail_hitbox_shape.disabled = false
	if tail_hitbox and not tail_hitbox.body_entered.is_connected(_on_enemy_hit):
		tail_hitbox.body_entered.connect(_on_enemy_hit)

func _on_process(delta: float) -> void:
	attack_timer -= delta

func _on_physics_process(delta: float) -> void:
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.friction * delta)
	player.move_and_slide()

func _on_next_transitions() -> void:
	if attack_timer <= 0.0:
		if GameInputEvents.is_movement_input():
			transition.emit("Walk")
		else:
			transition.emit("Idle")

func _on_exit() -> void:
	if tail_hitbox_shape:
		tail_hitbox_shape.disabled = true
	if tail_hitbox and tail_hitbox.body_entered.is_connected(_on_enemy_hit):
		tail_hitbox.body_entered.disconnect(_on_enemy_hit)

func _on_enemy_hit(body: Node2D) -> void:
	if body in hit_enemies:
		return
		
	if body.has_method("take_damage_and_knockback"):
		hit_enemies.append(body)
		
		var knockback_dir: Vector2 = player.global_position.direction_to(body.global_position)


		var charge_factor: float = player.last_charge_amount / player.max_charge_time
		var total_knockback_force: float = player.base_knockback * (1.0 + charge_factor * 1.5)
		var knockback_impulse: Vector2 = knockback_dir * total_knockback_force
		

		var damage: float = 20.0 * (1.0 + charge_factor)
		
		
		body.take_damage_and_knockback(damage, knockback_impulse)
