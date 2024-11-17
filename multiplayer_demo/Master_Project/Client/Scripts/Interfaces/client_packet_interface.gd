class_name CLIENT_PACKET_INTERFACE extends Object

# {"player_id" : connection_manager_c.player_id, "input_vec" : direction, "packet_id": current_packet}
var _packet_id : int
var _player_id : int
var _input_vector : Vector3
var _action_command : SettingsMp.ACTION_COMMAND_TYPE
var _skin_rotation : Vector3

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
