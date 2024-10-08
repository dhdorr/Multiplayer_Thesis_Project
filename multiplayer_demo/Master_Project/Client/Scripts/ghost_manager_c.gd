class_name Ghost_Manager_C extends Node

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C

const PLAYER_S = preload("res://Master_Project/Server/Scenes/player_s.tscn")

var ghost_dict : Dictionary


func spawn_peer_characters_2(world_state: Dictionary) -> void:
	for p_id : int in world_state:
		if p_id == connection_manager_c.player_id:
			continue
		var temp_vec : Vector2 = world_state[p_id]["position"]
		
		if !ghost_dict.has(p_id):
			ghost_dict[p_id] = PLAYER_S.instantiate()
			add_child(ghost_dict[p_id])
		
		move_ghost(world_state[p_id], p_id)


func move_ghost(player: Dictionary, p_id : int) -> void:
	ghost_dict[p_id].position = player["position"]

# Ghost manager should have its own input buffer for packets (fed from the
# buffer manager) to make it easier to interpolate entities independantly
# from the input manager
# this way we get as soon as possible updates for the player,
# and we can create a buffer for interpolation / rollback for the entities
