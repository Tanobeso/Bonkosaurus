class_name NodeStateMachine
extends Node

@export var initial_node_state: NodeState

var current_node_state: NodeState
var node_states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child
			child.transition.connect(_on_state_transition)

	if initial_node_state:
		current_node_state = initial_node_state
		current_node_state._on_enter()

func _process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)
		current_node_state._on_next_transitions()

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)

func _on_state_transition(target_state_name: String) -> void:
	var new_state: NodeState = node_states.get(target_state_name.to_lower())
	if not new_state or new_state == current_node_state:
		return

	if current_node_state:
		current_node_state._on_exit()

	current_node_state = new_state
	current_node_state._on_enter()
	
	current_node_state = new_state
	print("Current State: ", current_node_state.name)
