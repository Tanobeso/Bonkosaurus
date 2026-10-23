class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var max_speed: float = 180.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0
@export var rotation_speed: float = 8.0

@export_category("Combat")
@export var max_charge_time: float = 1.5
@export var base_knockback: float = 400.0

var last_charge_amount: float = 0.0

@onready var body_sprite: Sprite2D = $BodySprite
@onready var tail_pivot: Node2D = $TailPivot
@onready var tail_sprite: Sprite2D = $TailPivot/TailSprite
@onready var tail_hitbox: Area2D = $TailPivot/TailHitbox

func handle_tail_rotation() -> void:
	if tail_pivot:
		tail_pivot.look_at(get_global_mouse_position())
