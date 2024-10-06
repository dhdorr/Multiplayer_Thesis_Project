class_name Ghost_Manager_C extends Node

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C

const PLAYER_S = preload("res://Master_Project/Server/Scenes/player_s.tscn")

var ghost_dict : Dictionary

func spawn_peer_characters(packet: Dictionary) -> void:
	for ghost_id in packet:
		if ghost_id != connection_manager_c.player_id and not ghost_dict.has(ghost_id):
			var new_player : CharacterBody2D = PLAYER_S.instantiate()
			ghost_dict[ghost_id] = new_player
			add_child(new_player)
			new_player.position = packet[ghost_id]["position"]
		elif ghost_dict.has(ghost_id):
			# Will need to implement client side entity interpolation here
			# once interpolation is done, investigate rollback?
			ghost_dict[ghost_id].position = packet[ghost_id]["position"]
			ghost_dict[ghost_id].velocity = packet[ghost_id]["velocity"]
			ghost_dict[ghost_id].move_and_slide()
