class_name PACKET_MANAGER_C extends Node

#static var packet_interface := CLIENT_PACKET_INTERFACE.new()

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C
@onready var client_wrapper: Client_Wrapper = $".."

static var _packet_id: int = 0
static var _packet_history: Array[Dictionary]
#var _packet_history_2: Array[CLIENT_PACKET_INTERFACE]
# If last confirmed packet id == -1, then no packet has been confirmed
static var _last_confirmed_packet_id: int = -1
static var _confirmed_packet_id_history: Array[int]

# Reusing the same packet to avoid memory usage
@onready var _packet := CLIENT_PACKET_INTERFACE.Input_Packet.new(Vector3.ZERO, Vector3.ZERO, 0, -1, 0)


func _ready() -> void:
	SignalBusMp.player_id_received.connect(
		func(id: int) -> void:
			print("player id: ", id)
			_packet._player_id = id
			)


func create_connection_string_packet() -> Dictionary:
	var interface := CLIENT_PACKET_INTERFACE.Connection_Request.new( 
		client_wrapper.username, 
		client_wrapper.passcode, 
		SettingsMp.PLAYER_SKIN_ID.VIKING
		)
	var my_dict : Dictionary = interface._to_dictionary()
	return my_dict


func write_to_client_packet(input_vector: Vector3, action_command: int, skin_rotation: Vector3) -> void:
	_packet.regenerate_packet(input_vector, skin_rotation, action_command, _packet_id)
	
	var packet_dict : Dictionary = _packet._to_dictionary()
	append_to_packet_history(packet_dict)
	connection_manager_c.send_input_3D(packet_dict)
	
	_packet_id += 1


func append_to_packet_history(packet_d: Dictionary) -> void:
	_packet_history.append(packet_d)


func register_confirmed_packet(id: int) -> void:
	_last_confirmed_packet_id = id


func validate_packet(packet : Variant, expected_packet_type : int) -> bool:
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
			
			return true
	
	return false
