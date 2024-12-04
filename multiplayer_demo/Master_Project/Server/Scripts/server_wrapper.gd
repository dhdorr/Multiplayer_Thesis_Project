extends Node

enum SERVER_STATE_TYPES { OFF, WAITING_FOR_PLAYERS, STARTING_MATCH, RUNNING_MATCH }

const MAX_LOBBY_SIZE : int = 2

@onready var connection_manager_s: Connection_Manager_Server = %Connection_Manager_S
@onready var world_state_manager_s: World_State_Manager = %World_State_Manager_S
@onready var lobby_manager_s: LOBBY_MANAGER_S = %Lobby_Manager_S

var _server_state := SERVER_STATE_TYPES.OFF
var _peer_count : int = 0 
var _is_match_countdown_started := false

func _ready() -> void:
	SignalBusMp.setup_settings_toggle.connect(setup_settings_menu)
	SignalBusMp.update_peer_count.connect(_update_peer_count)
	SignalBusMp.lobby_start_match.connect(_set_server_state.bind(SERVER_STATE_TYPES.STARTING_MATCH))
	
	_start_server()


func _process(delta: float) -> void:
	if _server_state == SERVER_STATE_TYPES.OFF:
		return
	
	connection_manager_s.poll_server()
	
	if _server_state == SERVER_STATE_TYPES.WAITING_FOR_PLAYERS:
		connection_manager_s.listen_for_new_connections()
		connection_manager_s.listen_for_client_ready_ups()
	elif _server_state == SERVER_STATE_TYPES.STARTING_MATCH:
		if not _is_match_countdown_started:
			_is_match_countdown_started = true
			var timer := get_tree().create_timer(1.0).timeout.connect(_start_match)
		
	elif _server_state == SERVER_STATE_TYPES.RUNNING_MATCH:
		connection_manager_s.listen_for_client_input_packets()


func setup_settings_menu(proc_type: int) -> void:
	$Settings_Toggles.hide_settings(proc_type)


# Called from signal update_peer_count
func _update_peer_count(count: int) -> void:
	lobby_manager_s.send_out_lobby_update()
	
	_peer_count = count


func _start_match():
	_set_server_state(SERVER_STATE_TYPES.RUNNING_MATCH)
	lobby_manager_s.send_out_lobby_update()
	var vec_arr := [Vector3(1,0,1), Vector3(-1,0,1), Vector3(1,0,-1), Vector3(-1,0,-1)]
	var random_dir : Vector3 = vec_arr.pick_random()
	world_state_manager_s.bomb_ball_ref.move_the_ball(random_dir)


func _start_server():
	if connection_manager_s.start_server():
		_set_server_state(SERVER_STATE_TYPES.WAITING_FOR_PLAYERS)
	else:
		print("failed to start game server")


func _set_server_state(state: int):
	_server_state = state
