class_name Client_Wrapper extends Node

enum CLIENT_STATE_TYPES { HOME, CONNECTING_TO_SERVER, WAITING_IN_LOBBY, STARTING_MATCH, PLAYING_GAME }

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C
@onready var start_screen_menu: Start_Screen_Menu
#@onready var match_countdown_ui: Control = %Match_Countdown_UI

const LOBBY_UI = preload("res://Master_Project/Client/Scenes/lobby_ui.tscn")
const CHARACTER_CONTROLLER_3D = preload("res://Master_Project/Client/Scenes/character_controller_3d.tscn")
const WORLD_3D = preload("res://Master_Project/world_3d.tscn")
const MATCH_COUNTDOWN_UI = preload("res://Master_Project/Client/Scenes/match_countdown_ui.tscn")
const START_SCREEN_MENU = preload("res://Master_Project/Client/Scenes/start_screen_menu.tscn")
const SKIN_SELECTION_UI = preload("res://Master_Project/Client/Scenes/skin_selection_ui.tscn")

var player_init : Dictionary
var _client_state := CLIENT_STATE_TYPES.HOME
var _is_game_world_setup := false
var _is_lobby_setup := false
var _is_match_countdown_started := false
var _countdown_timer : Timer

var username : String = "John Wick"
var passcode : String = "hello, world!"

func _ready() -> void:
	SignalBusMp.update_client_label.connect(update_label)
	SignalBusMp.setup_settings_toggle.connect(setup_settings_menu)
	SignalBusMp.update_client_state.connect(_set_client_state)
	SignalBusMp.client_ready_up.connect(_send_out_ready_up)
	SignalBusMp.open_start_screen.connect(func() -> void:
		add_child(START_SCREEN_MENU.instantiate())
		)
	SignalBusMp.open_skin_selection.connect(func() -> void:
		add_child(SKIN_SELECTION_UI.instantiate())
		)


func _process(delta: float) -> void:
	if _client_state == CLIENT_STATE_TYPES.HOME:
		return
	elif _client_state == CLIENT_STATE_TYPES.CONNECTING_TO_SERVER:
		connection_manager_c.listen_for_connection_packets()
	
	elif _client_state == CLIENT_STATE_TYPES.WAITING_IN_LOBBY:
		if not _is_lobby_setup:
			_is_lobby_setup = true
			var _lobby_ui := LOBBY_UI.instantiate()
			add_child(_lobby_ui)
		
		if not _is_game_world_setup:
			setup_game_world()
		
		# listen for incomming lobby updates & send out ready up updates
		connection_manager_c.listen_for_lobby_packets()
		
	elif _client_state == CLIENT_STATE_TYPES.STARTING_MATCH:
		# start a timer before giving the player control over their character
		# give this a UI later
		if not _is_match_countdown_started:
			for l_ui in get_tree().get_nodes_in_group("lobby"):
				l_ui.queue_free()
			var countdown := MATCH_COUNTDOWN_UI.instantiate()
			add_child(countdown)
			_is_match_countdown_started = true
			SignalBusMp.start_match_countdown_animation.emit()
		
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


# load in the game world and character controller
# keep it in the background until the server confirms the match is starting
func setup_game_world() -> void:
	_is_game_world_setup = true
	
	# remove home screen
	$Start_Screen_Menu.queue_free()
	#start_screen_menu.queue_free()
	
	var world_scene := WORLD_3D.instantiate()
	add_child(world_scene)
	
	var player_scene := CHARACTER_CONTROLLER_3D.instantiate()
	add_child(player_scene)


func is_ready_to_send_input() -> bool:
	var client_ready : bool = _client_state == CLIENT_STATE_TYPES.PLAYING_GAME and connection_manager_c.connected
	return client_ready


func _send_out_ready_up(is_ready : bool) -> void:
	connection_manager_c.send_ready_up_to_server(is_ready)


# TODO add in client side states, like how the server wrapper does it.
# States should go from home screen -> connecting -> waiting in lobby -> playing game
func _set_client_state(state: int) -> void:
	_client_state = state
