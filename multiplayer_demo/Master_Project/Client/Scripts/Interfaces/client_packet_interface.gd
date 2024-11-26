class_name CLIENT_PACKET_INTERFACE extends Object


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


class Lobby_Ready_Up:
	var _message_id : int = SettingsMp.CLIENT_PACKET_TYPES.LOBBY_READY_UP
	var _is_ready : bool = false
	var _player_id : int
	var _client_version : String = SettingsMp.protocol_version
	
	func _init(is_ready : bool, player_id : int) -> void:
		_is_ready = is_ready
		_player_id = player_id
	
	func _to_dictionary() -> Dictionary:
		var my_dict : Dictionary = {
			"message_id" = _message_id,
			"is_ready" = _is_ready,
			"player_id" = _player_id,
			"version" = _client_version,
		}
		return my_dict


class Input_Packet:
	var _message_id : int = SettingsMp.CLIENT_PACKET_TYPES.INPUT_PACKET
	var _player_id : int
	var _input_vector : Vector3
	var _rotation_vector : Vector3
	var _action_command : int
	var _packet_id : int
	var _client_version : String = SettingsMp.protocol_version
	
	func _init(direction : Vector3, rotation : Vector3, action : int, packet_id: int, player_id : int) -> void:
		_input_vector = direction
		_rotation_vector = rotation
		_action_command = action
		_packet_id = packet_id
		_player_id = player_id
	
	func regenerate_packet(direction : Vector3, rotation : Vector3, action : int, packet_id: int) -> void:
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
			"player_id" = _player_id,
			"version" = _client_version,
		}
		return my_dict
