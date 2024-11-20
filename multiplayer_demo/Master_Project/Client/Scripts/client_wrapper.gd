class_name Client_Wrapper extends Node

enum CLIENT_STATE_TYPES { HOME, CONNECTING_TO_SERVER, WAITING_IN_LOBBY, STARTING_MATCH, PLAYING_GAME }

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C
@onready var start_screen_menu: Start_Screen_Menu = %Start_Screen_Menu

const CHARACTER_CONTROLLER_3D = preload("res://Master_Project/Client/Scenes/character_controller_3d.tscn")
const WORLD_3D = preload("res://Master_Project/world_3d.tscn")

var player_init : Dictionary
var _client_state := CLIENT_STATE_TYPES.HOME
var _is_game_world_setup := false
var _is_match_countdown_started := false

func _ready() -> void:
	SignalBusMp.update_client_label.connect(update_label)
	SignalBusMp.setup_settings_toggle.connect(setup_settings_menu)
	SignalBusMp.update_client_state.connect(_set_client_state)


func _process(delta: float) -> void:
	if _client_state == CLIENT_STATE_TYPES.HOME:
		return
	elif _client_state == CLIENT_STATE_TYPES.CONNECTING_TO_SERVER:
		connection_manager_c.listen_for_connection_packets()
	elif _client_state == CLIENT_STATE_TYPES.WAITING_IN_LOBBY:
		if not _is_game_world_setup:
			setup_game_world()
		connection_manager_c.listen_for_lobby_packets()
	elif _client_state == CLIENT_STATE_TYPES.STARTING_MATCH:
		# start a timer before giving the player control over their character
		# give this a UI later
		if not _is_match_countdown_started:
			_is_match_countdown_started = true
			var timer := get_tree().create_timer(3.0)
			timer.timeout.connect(_start_match)
		
	elif _client_state == CLIENT_STATE_TYPES.PLAYING_GAME:
		connection_manager_c.listen_for_world_state_packets()
	else:
		print("state error - invalid state: ", _client_state)
		get_tree().quit()


func update_label(p_id: int) -> void:
	$Label.text = "Client - " + str(p_id)


func setup_settings_menu(proc_type: int) -> void:
	$Settings_Toggles.hide_settings(proc_type)


# receive a signal to start a timer (3 seconds)
# on timeout, player will receive controll of their character
func _start_match() -> void:
	_set_client_state(CLIENT_STATE_TYPES.PLAYING_GAME)
	print("game on...")


# load in the game world and character controller
# keep it in the background until the server confirms the match is starting
func setup_game_world() -> void:
	_is_game_world_setup = true
	
	# remove home screen
	start_screen_menu.queue_free()
	
	var world_scene := WORLD_3D.instantiate()
	add_child(world_scene)
	
	var player_scene := CHARACTER_CONTROLLER_3D.instantiate()
	add_child(player_scene)


func is_ready_to_send_input() -> bool:
	var client_ready : bool = _client_state == CLIENT_STATE_TYPES.PLAYING_GAME and connection_manager_c.connected
	return client_ready


# TODO add in client side states, like how the server wrapper does it.
# States should go from home screen -> connecting -> waiting in lobby -> playing game
func _set_client_state(state: int) -> void:
	_client_state = state
