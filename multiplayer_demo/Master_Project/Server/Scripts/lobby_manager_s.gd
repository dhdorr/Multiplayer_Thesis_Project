class_name LOBBY_MANAGER_S extends Node

const MAX_LOBBY_SIZE := 2

@onready var connection_manager_s: Connection_Manager_Server = %Connection_Manager_S
@onready var world_state_manager_s: World_State_Manager = %World_State_Manager_S

var _lobby_player_list : Array[Dictionary]
var lobby_status : SettingsMp.GLOBAL_LOBBY_STATUS = SettingsMp.GLOBAL_LOBBY_STATUS.OPEN
var _all_players_ready : bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if lobby_status == SettingsMp.GLOBAL_LOBBY_STATUS.CLOSED:
		var all_players_ready = true
		for player in _lobby_player_list:
			#print("checking if is ready...", player)
			if player["is_ready"] == false:
				all_players_ready = false
		_all_players_ready = all_players_ready
		if _all_players_ready:
			# this should become, when all players are READY, start match
			lobby_status = SettingsMp.GLOBAL_LOBBY_STATUS.START_MATCH
			SignalBusMp.lobby_start_match.emit()


func add_new_player_to_lobby(username : String, skin_id : int, player_id : int) -> void:
	# generate player id
	#var player_id : int = randi_range(1, 255)
	
	var player := LOBBY_MANAGER_S.Player.new(username, player_id, skin_id, false)
	var player_dict : Dictionary = player._to_dictionary()
	
	_lobby_player_list.append(player_dict)
	_update_lobby_status()
	
	#return player_id


func _update_lobby_status() -> void:
	if _lobby_player_list.size() == MAX_LOBBY_SIZE:
		lobby_status = SettingsMp.GLOBAL_LOBBY_STATUS.CLOSED


func update_lobby_player_status(player_id : int, is_ready : bool):
	for player in _lobby_player_list:
		if player["player_id"] == player_id:
			player["is_ready"] = is_ready
	
	send_out_lobby_update()


# called from the server wrapper state machine
func send_out_lobby_update() -> void:
	var lobby_update := SERVER_PACKET_INTERFACE.Lobby_Update.new(lobby_status)
	
	for p in _lobby_player_list:
		var player_ref : CharacterBody3D = world_state_manager_s.server_player_dict[p["player_id"]]
		lobby_update.add_new_player_to_list(p["player_id"], p["username"], p["skin_id"], player_ref.position, player_ref.rotation, p["is_ready"])
	
	connection_manager_s.update_lobby_to_clients(lobby_update._to_dictionary())


class Player:
	var _username : String
	var _player_id : int
	var _skin_id : int
	var _is_ready : bool
	
	func _init(username : String, player_id : int, skin_id : int, is_ready : bool):
		_username = username
		_player_id = player_id
		_skin_id = skin_id
		_is_ready = is_ready
	
	func _to_dictionary() -> Dictionary:
		var my_dict : Dictionary = {
			"username" = _username,
			"player_id" = _player_id,
			"skin_id" = _skin_id,
			"is_ready" = _is_ready,
		}
		return my_dict
