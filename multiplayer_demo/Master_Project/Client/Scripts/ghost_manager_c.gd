class_name Ghost_Manager_C extends Node

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C

const PLAYER_GHOST_C_3D = preload("res://Master_Project/Client/Scenes/player_ghost_c_3d.tscn")

var ghost_dict : Dictionary

var prev_ghost_pos_dict : Dictionary
var bomb_ball_ref_client : Bomb_Ball_Server

func add_new_ghost(lobby_player_list: Array[Dictionary]) -> bool:
	var is_new_ghost_added := false
	for lobby_player in lobby_player_list:
		var player_id : int = lobby_player["player_id"]
		if player_id == connection_manager_c.player_id:
			continue
		
		if not ghost_dict.has(player_id):
			is_new_ghost_added = true
			var ghost : PLAYER_GHOST_CLIENT = PLAYER_GHOST_C_3D.instantiate()
			ghost_dict[player_id] = ghost
			
			ghost.position = lobby_player["position"]
			ghost._target_position = ghost.position
			ghost.rotation = lobby_player["rotation"]
			
			add_child(ghost)
			
			ghost.nameplate.text = lobby_player["username"]
			print("recieved name: ", lobby_player["username"])
			print("...")
			print(lobby_player)
			prev_ghost_pos_dict[player_id] = ghost.position
			print("ghost position: ", ghost.position)
	return is_new_ghost_added
	#for player_id : int in lobby_dict:
		#if player_id == connection_manager_c.player_id:
			#continue
		#
		#if not ghost_dict.has(player_id):
			#is_new_ghost_added = true
			#var ghost : PLAYER_GHOST_CLIENT = PLAYER_GHOST_C_3D.instantiate()
			#ghost_dict[player_id] = ghost
			#
			#ghost.position = lobby_dict[player_id]["position"]
			#ghost._target_position = ghost.position
			#ghost.rotation = lobby_dict[player_id]["rotation"]
			#add_child(ghost)
			#prev_ghost_pos_dict[player_id] = ghost.position
			#print("ghost position: ", ghost.position)
	#return is_new_ghost_added


func spawn_peer_characters_2(world_state: Dictionary) -> void:
	for p_id : int in world_state:
		if p_id == connection_manager_c.player_id:
			continue
		
		if !ghost_dict.has(p_id):
			var ghost : PLAYER_GHOST_CLIENT = PLAYER_GHOST_C_3D.instantiate()
			ghost_dict[p_id] = ghost
			add_child(ghost)
			ghost.position = world_state[p_id]["position"]
			prev_ghost_pos_dict[p_id] = world_state[p_id]["position"]
			ghost.rotation = world_state[p_id]["rotation"]
		
		move_ghost(world_state[p_id], p_id)

# Entity interpolation
func move_ghost(player: Dictionary, p_id: int) -> void:
	var ghost : PLAYER_GHOST_CLIENT = ghost_dict[p_id]
	ghost._skin_rotation =  player["skin_rotation"]
	ghost._target_position = player["position"]
	ghost._last_input = player["last_input"]
	update_prev_ghost_pos(p_id, player["position"])


func update_prev_ghost_pos(p_id: int, pos: Vector3) -> void:
	prev_ghost_pos_dict[p_id] = pos


func move_ball(bomb_ball_state : Dictionary) -> void:
	if bomb_ball_ref_client == null:
		bomb_ball_ref_client = get_tree().get_first_node_in_group("ball")
	# gotta design a way to predict ball motion so player isn't hundreds of ms behind
	bomb_ball_ref_client.position = bomb_ball_state["position"]
	bomb_ball_ref_client.rotation = bomb_ball_state["rotation"]
	#bomb_ball_ref_client.temp_speed = 12
	bomb_ball_ref_client.linear_velocity = bomb_ball_state["velocity"]
	if SettingsMp.enable_client_dead_reckoning:
		bomb_ball_ref_client.forward_simulate(SettingsMp.server_tick_rate - 1)
	
# Ghost manager should have its own input buffer for packets (fed from the
# buffer manager) to make it easier to interpolate entities independantly
# from the input manager
# this way we get as soon as possible updates for the player,
# and we can create a buffer for interpolation / rollback for the entities
