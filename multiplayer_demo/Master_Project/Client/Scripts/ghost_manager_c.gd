class_name Ghost_Manager_C extends Node

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C

const PLAYER_S = preload("res://Master_Project/Server/Scenes/player_s.tscn")

var ghost_dict : Dictionary

var prev_ghost_pos_dict : Dictionary


func spawn_peer_characters_2(world_state: Dictionary) -> void:
	for p_id : int in world_state:
		if p_id == connection_manager_c.player_id:
			continue
		
		if !ghost_dict.has(p_id):
			ghost_dict[p_id] = PLAYER_S.instantiate()
			add_child(ghost_dict[p_id])
			
			prev_ghost_pos_dict[p_id] = world_state[p_id]["position"]
		
		move_ghost(world_state[p_id], p_id)

# Entity interpolation
func move_ghost(player: Dictionary, p_id : int) -> void:
	#ghost_dict[p_id].position = player["position"]
	
	ghost_dict[p_id].position = prev_ghost_pos_dict[p_id]
	var tween := get_tree().create_tween()
	tween.tween_property(ghost_dict[p_id],"position", player["position"], SettingsMp.get_server_tick_rate() * get_physics_process_delta_time())
	prev_ghost_pos_dict[p_id] = player["position"]

# Ghost manager should have its own input buffer for packets (fed from the
# buffer manager) to make it easier to interpolate entities independantly
# from the input manager
# this way we get as soon as possible updates for the player,
# and we can create a buffer for interpolation / rollback for the entities
