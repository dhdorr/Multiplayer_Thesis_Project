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
