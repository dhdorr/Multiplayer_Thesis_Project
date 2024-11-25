class_name Packet_Manager_S extends Node

@onready var connection_manager_s: Node = %Connection_Manager_S
var packets_dict : Dictionary

func generate_world_state_update_packet(pos : Vector2) -> void:

	print("packet generated...")

func send_world_state_update() -> void:
	
	connection_manager_s.send_world_state_updates_to_clients_2(packets_dict)


func validate_packet(packet : Variant, expected_packet_type : int, expected_passcode : String = "") -> bool:
	match typeof(packet):
		TYPE_DICTIONARY:
			if not packet.has_all(["version", "message_id"]):
				print("invalid packet structure: ", packet)
				return false
			if packet["version"] != SettingsMp.protocol_version:
				print("invalid packet version: ", packet)
				return false
			if packet["message_id"] != expected_packet_type:
				print("invalid packet type: ", packet)
				return false
			if packet["message_id"] == SettingsMp.CLIENT_PACKET_TYPES.CONNECTION_REQUEST and packet.has("passcode"):
				if packet["passcode"] != expected_passcode:
					print("invalid passcode: ", packet)
					return false
			elif packet["message_id"] == SettingsMp.CLIENT_PACKET_TYPES.CONNECTION_REQUEST and not packet.has("passcode"):
				print("invalid connection request: ", packet)
				return false
			
			return true
	
	return false
