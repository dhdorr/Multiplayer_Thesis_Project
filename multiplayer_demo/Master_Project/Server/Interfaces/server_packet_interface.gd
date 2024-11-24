class_name SERVER_PACKET_INTERFACE extends Node

class player_initialization_response:
	var _position	: Vector3
	var _player_id	: int
	var _rotation	: Vector3
	
	func _init(player_id: int, position: Vector3, rotation: Vector3) -> void:
		_player_id = player_id
		_position = position
		_rotation = rotation
	
	func packet_as_dict() -> Dictionary:
		return {
			"player_id": _player_id,
			"position": _position,
			"rotation": _rotation,
		}

class world_state_update:
	var players : Array[Dictionary]


class Connection_Response:
	var _message_id : int = SettingsMp.SERVER_PACKET_TYPES.CONNECTION_RESPONSE
	var _player_init_data : Dictionary
	var _server_version : String = SettingsMp.protocol_version
	
	func _init(player_id : int, position : Vector3, rotation : Vector3) -> void:
		_player_init_data = {
			"player_id" = player_id,
			"position" = position,
			"rotation" = rotation,
		}
	
	func _to_dictionary() -> Dictionary:
		var my_dict : Dictionary = {
			"message_id" = _message_id,
			"player_init_data" = _player_init_data,
			"version" = _server_version,
		}
		return my_dict
