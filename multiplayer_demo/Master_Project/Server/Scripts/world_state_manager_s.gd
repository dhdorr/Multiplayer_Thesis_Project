class_name World_State_Manager extends Node

@onready var connection_manager_s: Connection_Manager_Server = %Connection_Manager_S
const PLAYER_S = preload("res://Master_Project/Server/Scenes/player_s.tscn")

# this will be refactored to a dictionary of an array for each player
var player_input_buffer : Array[Vector2]
var last_input : Vector2 = Vector2.ZERO
# key = string, value = variant
var world_state_dict : Dictionary
var packet_id := 0

var player_packets : Array[Dictionary]

var delay := 10
var count := 0

var server_player_dict : Dictionary

func get_input_dict(input_dict : Dictionary) -> void:
	player_packets.append(input_dict)
	
	
func _physics_process(delta: float) -> void:
	count += 1
	if count < delay:
		return
	else:
		count = 0
	
	var index : int = 0
	for pp in player_packets:
		server_player_dict[pp["player_id"]].velocity = calculate_movement(server_player_dict[pp["player_id"]], pp["input_vec"], delta)
		server_player_dict[pp["player_id"]].move_and_slide()
		
		world_state_dict[pp["player_id"]] = {"position": server_player_dict[pp["player_id"]].position, "packet_id": pp["packet_id"], "velocity": server_player_dict[pp["player_id"]].velocity}
	
	if player_packets.size() > 0:
		connection_manager_s.send_world_state_updates_to_clients_2(world_state_dict)
		player_packets.clear()
		

func calculate_movement(player: CharacterBody2D, dir : Vector2, delta : float) -> Vector2:
	var desired_velocity = dir * 300.0
	return player.velocity.move_toward(desired_velocity, delta * 1600.0)
	#return desired_velocity

func init_player_positions(packet: Dictionary) -> void:
	var new_player : CharacterBody2D = PLAYER_S.instantiate()
	add_child(new_player)
	server_player_dict[packet["player_id"]] = new_player
	new_player.position = packet["position"]
