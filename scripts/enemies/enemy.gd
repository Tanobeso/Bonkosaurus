class_name Enemy
extends CharacterBody2D

@export_category("Stats")
@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var speed: float = 90.0

@export_category("Knockback")
@export var knockback_friction: float = 1200.0

var knockback_velocity: Vector2 = Vector2.ZERO
var target_player: Node2D = null

func _ready() -> void:
	current_health = max_health
	target_player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if knockback_velocity.length() > 10.0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
		velocity = knockback_velocity
	else:
		knockback_velocity = Vector2.ZERO
		move_towards_player(delta)

	move_and_slide()

func move_towards_player(_delta: float) -> void:
	if target_player:
		var direction: Vector2 = global_position.direction_to(target_player.global_position)
		velocity = direction * speed
		
		rotation = lerp_angle(rotation, direction.angle(), 0.1)
	else:
		velocity = Vector2.ZERO

func take_damage_and_knockback(amount: float, knockback_impulse: Vector2) -> void:
	current_health -= amount
	knockback_velocity = knockback_impulse
	
	flash_hit()

	if current_health <= 0:
		die()

func flash_hit() -> void:
	var sprite: Sprite2D = get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = Color.RED
		var tween: Tween = create_tween()
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)

func die() -> void:
	queue_free()
