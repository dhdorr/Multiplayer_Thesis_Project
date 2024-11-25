class_name World_State_Manager extends Node

## The maximum speed the player can move at in meters per second.
@export_range(3.0, 12.0, 0.1) var max_speed := 6.0
## Controls how quickly the player accelerates and turns on the ground.
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0

const GRAVITY := 40.0 * Vector3.DOWN

@onready var connection_manager_s: Connection_Manager_Server = %Connection_Manager_S
const PLAYER_S = preload("res://Master_Project/Server/Scenes/player_s.tscn")
const PLAYER_S_3D = preload("res://Master_Project/Server/Scenes/player_s_3d.tscn")
@onready var world_3d: Node3D = $"../World_3D"
var spawn_points : Array[Marker3D]
var used_spawn_points : Array[int]

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

func register_pleyer_input(packet : Dictionary) -> void:
	#var input_dict : Dictionary = { 
		#"player_id": packet["player_id"], 
		#"packet_id": packet["packet_id"], 
		#"input_vec": packet["direction"],
		#"skin_rotation": packet["rotation"],
		#}
	player_packets.append(packet)


func _ready() -> void:
	spawn_points.append_array(get_tree().get_nodes_in_group("spawn"))


func _physics_process(delta: float) -> void:
	
	if count >= SettingsMp.get_server_tick_rate():
		var world_state_update := SERVER_PACKET_INTERFACE.World_State_Update.new(update_packet_id)
		
		for pp in player_packets:
			# Disable if not using 3D #
			var player_velocity : Vector3 = server_player_dict[pp["player_id"]].velocity
			var player_basis : Basis = server_player_dict[pp["player_id"]].global_basis
			var desired_velocity : Vector3 = calculate_movement_3D(delta, player_velocity, pp["direction"], player_basis)
			server_player_dict[pp["player_id"]].velocity = desired_velocity
			
			var player_ghost : PLAYER_SKIN_SERVER = server_player_dict[pp["player_id"]]
			player_ghost.rotate_skin(pp["rotation"])
			
			server_player_dict[pp["player_id"]].move_and_slide()
			# ----------------------- #
			
			world_state_update.add_player_state(
				pp["player_id"],
				server_player_dict[pp["player_id"]].position,
				server_player_dict[pp["player_id"]].rotation,
				player_ghost.ghost_skin_3d.rotation,
				server_player_dict[pp["player_id"]].velocity,
				pp["direction"],
				pp["packet_id"],
			)
			#world_state_dict[pp["player_id"]] = {
				#"position": server_player_dict[pp["player_id"]].position, 
				#"rotation": server_player_dict[pp["player_id"]].rotation,
				#"skin_rotation": player_ghost.ghost_skin_3d.rotation,
				#"last_input": pp["input_vec"],
				#"packet_id": pp["packet_id"], 
				#"velocity": server_player_dict[pp["player_id"]].velocity,
				#"server_update_id": update_packet_id,
				#}
		if player_packets.size() > 0:
			connection_manager_s.send_world_state_updates_to_clients_2(world_state_update._to_dictionary())
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
	new_player.position = packet["position"]
	server_player_dict[packet["player_id"]] = new_player
	add_child(new_player)


# Disable if not using 3D scenes #
func calculate_movement_3D(delta : float, player_velocity_ref : Vector3, direction : Vector3, basis: Basis) -> Vector3:
	var forward : Vector3 = basis.z
	var right : Vector3 = basis.x
	var move_direction : Vector3 = forward * direction.z + right * direction.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var desired_ground_velocity : Vector3 = max_speed * move_direction
	var steering_vector : Vector3 = desired_ground_velocity - player_velocity_ref
	steering_vector.y = 0.0
	
	# We limit the steering amount to ensure the velocity can never overshoots the
	# desired velocity.
	var steering_amount : float = min(steering_factor * delta, 1.0)
	player_velocity_ref += steering_vector * steering_amount
	
	player_velocity_ref += GRAVITY * delta
	
	return player_velocity_ref

# called from connection manager s
func init_player_positions_3D(player_id: int) -> Array[Vector3]:
	var new_player : CharacterBody3D = PLAYER_S_3D.instantiate()
	
	
	var spawn_point_id : int = pick_spawn_point()
	var spawn_point : Marker3D = spawn_points[spawn_point_id]
	
	#new_player.position = packet["position"]
	#new_player.rotation_degrees = packet["rotation"]
	new_player.position = spawn_point.position
	new_player.rotation = spawn_point.rotation
	add_child(new_player)
	server_player_dict[player_id] = new_player
	return [spawn_point.position, spawn_point.rotation]


func pick_spawn_point() -> int:
	print(used_spawn_points)
	var choice : int = 0
	if used_spawn_points.is_empty():
		used_spawn_points.append(0)
		choice = 0
	else:
		for i in range(spawn_points.size()):
			if not used_spawn_points.has(i):
				used_spawn_points.append(i)
				choice = i
	return choice
