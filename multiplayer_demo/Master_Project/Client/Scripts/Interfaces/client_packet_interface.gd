class_name CLIENT_PACKET_INTERFACE extends Object

# {"player_id" : connection_manager_c.player_id, "input_vec" : direction, "packet_id": current_packet}
var _packet_id : int
var _player_id : int
var _input_vector : Vector3
var _action_command : SettingsMp.ACTION_COMMAND_TYPE
var _skin_rotation : Vector3

#var _client_version : String = "help"

# init funciton must be overloaded in order to enforce interface fulfilment
func _init(packet_id: int, player_id: int, input_vector: Vector3, action_command: SettingsMp.ACTION_COMMAND_TYPE, skin_rotation: Vector3) -> void:
	_packet_id = packet_id
	_player_id = player_id
	_input_vector = input_vector
	_action_command = action_command
	_skin_rotation = skin_rotation
	
func packet_as_dict() -> Dictionary:
	var packet_dict : Dictionary = {
		"packet_id": _packet_id,
		"player_id": _player_id,
		"input_vector": _input_vector,
		"action_command": _action_command,
		"skin_rotation": _skin_rotation,
		}
	return packet_dict


class Connection_Request:
	var _message_id : int = SettingsMp.CLIENT_PACKET_TYPES.CONNECTION_REQUEST
	var _username : String
	var _passcode : String
	var _skin_id : int
	var _client_version : String = SettingsMp.protocol_version
	
	func _init(username : String, passcode : String, skin_id : int) -> void:
		_username = username
		_passcode = passcode
		_skin_id = skin_id
	
	func _to_dictionary() -> Dictionary:
		var my_dict : Dictionary = {
			"message_id" = _message_id,
			"username" = _username,
			"passcode" = _passcode,
			"skin_id" = _skin_id,
			"version" = _client_version,
		}
		return my_dict


class Input_Packet:
	var _message_id : int = SettingsMp.CLIENT_PACKET_TYPES.INPUT_PACKET
	var _input_vector : Vector3
	var _rotation_vector : Vector3
	var _action_command : int
	var _packet_id : int
	var _client_version : String = SettingsMp.protocol_version
	
	func _init(direction : Vector3, rotation : Vector3, action : int, packet_id: int) -> void:
		_input_vector = direction
		_rotation_vector = rotation
		_action_command = action
		_packet_id = packet_id
	
	func _to_dictionary() -> Dictionary:
		var my_dict : Dictionary = {
			"message_id" = _message_id,
			"direction" = _input_vector,
			"rotation" = _rotation_vector,
			"action" = _action_command,
			"packet_id" = _packet_id,
			"version" = _client_version,
		}
		return my_dict
