class_name CLIENT_PACKET_INTERFACE extends Object

# {"player_id" : connection_manager_c.player_id, "input_vec" : direction, "packet_id": current_packet}
var _packet_id : int
var _player_id : int
var _input_vector : Vector3
var _action_command : SettingsMp.ACTION_COMMAND_TYPE
var hello := "hello?"

# init funciton must be overloaded in order to enforce interface fulfilment
func _init(packet_id: int = -1, player_id: int = -1, input_vector: Vector3 = Vector3.INF, action_command: SettingsMp.ACTION_COMMAND_TYPE = -1) -> void:
	_packet_id = packet_id
	_player_id = player_id
	_input_vector = input_vector
	_action_command = action_command
	
