extends Node

@onready var connection_manager_s: Node = %Connection_Manager_S

# this will be refactored to a dictionary of an array for each player
var player_input_buffer : Array[Vector2]
var last_input : Vector2 = Vector2.ZERO

func get_input(input_vec : Vector2) -> void:
	player_input_buffer.append(input_vec)

func _physics_process(delta: float) -> void:
	if player_input_buffer.size() > 0:
		last_input = player_input_buffer.pop_front()
		var desired_velocity : Vector2 = last_input * 300.0
		$CharacterBody2D.velocity = $CharacterBody2D.velocity.move_toward(desired_velocity, delta * 1500.0)
		$CharacterBody2D.move_and_slide()
		
	else:
		$CharacterBody2D.velocity = $CharacterBody2D.velocity.move_toward(last_input * 300.0, delta * 1500.0)
		$CharacterBody2D.move_and_slide()
	
	send_world_state_update($CharacterBody2D.position)

func send_world_state_update(input_vector : Vector2) -> void:
	connection_manager_s.send_world_state_updates_to_clients(input_vector)
