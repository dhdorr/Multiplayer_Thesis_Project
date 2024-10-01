class_name World_State_Manager extends Node

@onready var connection_manager_s: Connection_Manager_Server = %Connection_Manager_S

# this will be refactored to a dictionary of an array for each player
var player_input_buffer : Array[Vector2]
var last_input : Vector2 = Vector2.ZERO
# key = string, value = variant
var world_state_dict : Dictionary
var packet_id := 0

var player_packets : Array[Dictionary]

var delay := 10
var count := 0

func get_input_dict(input_dict : Dictionary) -> void:
	player_packets.append(input_dict)
	
	
func _physics_process(delta: float) -> void:
	count += 1
	if count < delay:
		return
	else:
		count = 0
	
	for pp in player_packets:

		$CharacterBody2D.velocity = calculate_movement(pp["input_vec"], $CharacterBody2D.velocity, delta)
		$CharacterBody2D.move_and_slide()
		
		world_state_dict[pp["player_id"]] = {"position": $CharacterBody2D.position, "packet_id": pp["packet_id"]}
	if player_packets.size() > 0:
		connection_manager_s.send_world_state_updates_to_clients_2(world_state_dict)
		player_packets.clear()
		

func calculate_movement(dir : Vector2, vel: Vector2, delta : float) -> Vector2:
	var desired_velocity = dir * 300.0
	return desired_velocity
