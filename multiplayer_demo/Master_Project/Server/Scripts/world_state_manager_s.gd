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
		var desired_velocity : Vector2 = pp["input_vec"] * 300.0
		#$CharacterBody2D.velocity = $CharacterBody2D.velocity.move_toward(desired_velocity, delta * 1600.0)
		$CharacterBody2D.velocity = pp["input_vec"]
		$CharacterBody2D.move_and_slide()
		
		world_state_dict[pp["player_id"]] = {"position": $CharacterBody2D.position, "packet_id": pp["packet_id"]}
	if player_packets.size() > 0:
		connection_manager_s.send_world_state_updates_to_clients_2(world_state_dict)
		player_packets.clear()
		
