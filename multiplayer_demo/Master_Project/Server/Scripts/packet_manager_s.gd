class_name Packet_Manager_S extends Node

@onready var connection_manager_s: Node = %Connection_Manager_S
var packets_dict : Dictionary

func generate_world_state_update_packet(pos : Vector2) -> void:

	print("packet generated...")

func send_world_state_update() -> void:
	
	connection_manager_s.send_world_state_updates_to_clients_2(packets_dict)
