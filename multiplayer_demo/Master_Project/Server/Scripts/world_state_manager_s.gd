class_name World_State_Manager extends Node

## The maximum speed the player can move at in meters per second.
@export_range(3.0, 12.0, 0.1) var max_speed := 6.0
## Controls how quickly the player accelerates and turns on the ground.
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0

const GRAVITY := 40.0 * Vector3.DOWN

@onready var connection_manager_s: Connection_Manager_Server = %Connection_Manager_S
const PLAYER_S = preload("res://Master_Project/Server/Scenes/player_s.tscn")
const PLAYER_S_3D = preload("res://Master_Project/Server/Scenes/player_s_3d.tscn")

# this will be refactored to a dictionary of an array for each player
var player_input_buffer : Array[Vector2]
var last_input : Vector2 = Vector2.ZERO
# key = string, value = variant
var world_state_dict : Dictionary
var update_packet_id := 1

var player_packets : Array[Dictionary]

#var delay := 10
var count := 0

var server_player_dict : Dictionary

func get_input_dict(packet : Dictionary) -> void:
	var input_dict : Dictionary = { 
		"player_id": packet["player_id"], 
		"packet_id": packet["packet_id"], 
		"input_vec": packet["input_vector"],
		}
	player_packets.append(input_dict)

func get_input_dict_3D(packet : CLIENT_PACKET_INTERFACE) -> void:
	var input_dict : Dictionary = { 
		"player_id": packet._player_id, 
		"packet_id": packet._packet_id, 
		"input_vec": packet._input_vector,
		}
	player_packets.append(input_dict)
	
	
func _physics_process(delta: float) -> void:
	
	if count >= SettingsMp.get_server_tick_rate():
		for pp in player_packets:
			
			# Disable if not using 3D #
			var player_velocity : Vector3 = server_player_dict[pp["player_id"]].velocity
			var desired_velocity : Vector3 = calculate_movement_3D(delta, player_velocity, pp["input_vec"])
			server_player_dict[pp["player_id"]].velocity = desired_velocity
			server_player_dict[pp["player_id"]].move_and_slide()
			# ----------------------- #
			
			#server_player_dict[pp["player_id"]].velocity = calculate_movement(server_player_dict[pp["player_id"]], pp["input_vec"], delta)
			#server_player_dict[pp["player_id"]].move_and_slide()
			
			world_state_dict[pp["player_id"]] = {
				"position": server_player_dict[pp["player_id"]].position, 
				"packet_id": pp["packet_id"], 
				"velocity": server_player_dict[pp["player_id"]].velocity,
				"server_update_id": update_packet_id,
				}

		if player_packets.size() > 0:
			connection_manager_s.send_world_state_updates_to_clients_2(world_state_dict)
			update_packet_id += 1
			player_packets.clear()
			
		count = 0
	else:
		count += 1
	


func calculate_movement(player: CharacterBody2D, dir : Vector2, delta : float) -> Vector2:
	var desired_velocity = dir * 300.0
	return player.velocity.move_toward(desired_velocity, delta * 1600.0)
	#return desired_velocity

func init_player_positions(packet: Dictionary) -> void:
	var new_player : CharacterBody2D = PLAYER_S.instantiate()
	add_child(new_player)
	server_player_dict[packet["player_id"]] = new_player
	new_player.position = packet["position"]


# Disable if not using 3D scenes #
func calculate_movement_3D(delta : float, player_velocity_ref : Vector3, direction : Vector3) -> Vector3:
	var desired_ground_velocity : Vector3 = max_speed * direction
	var steering_vector : Vector3 = desired_ground_velocity - player_velocity_ref
	steering_vector.y = 0.0
	
	# We limit the steering amount to ensure the velocity can never overshoots the
	# desired velocity.
	var steering_amount : float = min(steering_factor * delta, 1.0)
	player_velocity_ref += steering_vector * steering_amount
	
	player_velocity_ref += GRAVITY * delta
	
	return player_velocity_ref

# called from connection manager s
func init_player_positions_3D(packet: Dictionary) -> void:
	var new_player : CharacterBody3D = PLAYER_S_3D.instantiate()
	add_child(new_player)
	server_player_dict[packet["player_id"]] = new_player
	new_player.position = packet["position"]
