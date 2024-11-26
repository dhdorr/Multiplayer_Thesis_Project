class_name SERVER_PACKET_INTERFACE extends Node


class World_State_Update:
	# may become an array[dictionary], but would require changes in buffer manager on the cliet
	var _player_states : Dictionary
	var _message_id : int = SettingsMp.SERVER_PACKET_TYPES.WORLD_STATE_UPDATE
	var _server_version : String = SettingsMp.protocol_version
	var _server_update_id : int
	
	func _init(update_id : int) -> void:
		_server_update_id = update_id
	
	func add_player_state(player_id : int, position : Vector3, rotation : Vector3, skin_rotation : Vector3, velocity : Vector3, last_input : Vector3, last_received_packet_id : int) -> void:
		_player_states[player_id] = {
			"position" = position,
			"rotation" = rotation,
			"skin_rotation" = skin_rotation,
			"velocity" = velocity,
			"last_input" = last_input,
			"last_received_packet_id" = last_received_packet_id,
		}
	
	func _to_dictionary() -> Dictionary:
		var my_dict : Dictionary = {
			"message_id" = _message_id,
			"player_states" = _player_states,
			"server_update_id" = _server_update_id,
			"version" = _server_version,
		}
		return my_dict


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


class Lobby_Update:
	var _message_id : int = SettingsMp.SERVER_PACKET_TYPES.LOBBY_UPDATE
	var _list_of_players : Array[Dictionary]
	var _server_version : String = SettingsMp.protocol_version
	var _lobby_status : int
	
	func _init(status : int) -> void:
		_lobby_status = status
	
	func add_new_player_to_list(player_id : int, username : String, skin_id : int, position : Vector3, rotation : Vector3, is_ready : bool) -> void:
		var new_player : Dictionary = {
			"player_id" = player_id,
			"username" = username,
			"position" = position,
			"rotation" = rotation,
			"skin_id" = skin_id,
			"is_ready" = is_ready,
		}
		_list_of_players.append(new_player)
	
	func _to_dictionary() -> Dictionary:
		var my_dict : Dictionary = {
			"message_id" = _message_id,
			"list_of_players" = _list_of_players,
			"lobby_status" = _lobby_status,
			"version" = _server_version,
		}
		return my_dict
