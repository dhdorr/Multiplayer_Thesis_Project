class_name LOBBY_MANAGER_S extends Node

const MAX_LOBBY_SIZE := 2

@onready var connection_manager_s: Connection_Manager_Server = %Connection_Manager_S
@onready var world_state_manager_s: World_State_Manager = %World_State_Manager_S

var _lobby_player_list : Array[Dictionary]
var lobby_status : SettingsMp.GLOBAL_LOBBY_STATUS = SettingsMp.GLOBAL_LOBBY_STATUS.OPEN

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if lobby_status == SettingsMp.GLOBAL_LOBBY_STATUS.CLOSED:
		# this should become, when all players are READY, start match
		lobby_status = SettingsMp.GLOBAL_LOBBY_STATUS.START_MATCH
		print("tell clients to start match...")
		SignalBusMp.lobby_start_match.emit()


func add_new_player_to_lobby(username : String, skin_id : int) -> int:
	# generate player id
	var player_id : int = randi_range(1, 255)
	
	var player := LOBBY_MANAGER_S.Player.new(username, player_id, skin_id)
	var player_dict : Dictionary = player._to_dictionary()
	print(player_dict)
	
	_lobby_player_list.append(player_dict)
	_update_lobby_status()
	
	return player_id


func _update_lobby_status() -> void:
	if _lobby_player_list.size() == MAX_LOBBY_SIZE:
		lobby_status = SettingsMp.GLOBAL_LOBBY_STATUS.CLOSED
	print("Lobby Status: ", lobby_status)


# called from the server wrapper state machine
func send_out_lobby_update() -> void:
	var lobby_update := SERVER_PACKET_INTERFACE.Lobby_Update.new(lobby_status)
	
	for p in _lobby_player_list:
		var player_ref : CharacterBody3D = world_state_manager_s.server_player_dict[p["player_id"]]
		lobby_update.add_new_player_to_list(p["player_id"], p["username"], p["skin_id"], player_ref.position, player_ref.rotation)
	
	connection_manager_s.update_lobby_to_clients(lobby_update._to_dictionary())


class Player:
	var _username : String
	var _player_id : int
	var _skin_id : int
	
	func _init(username : String, player_id : int, skin_id : int):
		_username = username
		_player_id = player_id
		_skin_id = skin_id
	
	func _to_dictionary() -> Dictionary:
		var my_dict : Dictionary = {
			"username" = _username,
			"player_id" = _player_id,
			"skin_id" = _skin_id,
		}
		return my_dict
