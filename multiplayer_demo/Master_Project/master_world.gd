extends Node

## Adjust the number of network ticks per second of the server.
## Higher ticks per second means a more responsive server.
@export_range(1, 60, 1) var server_tick_rate := 10

const CLIENT_WRAPPER = preload("res://Master_Project/Client/Scenes/client_wrapper.tscn")
const SERVER_WRAPPER = preload("res://Master_Project/Server/Scenes/server_wrapper.tscn")
const START_SCREEN_MENU = preload("res://Master_Project/Client/Scenes/start_screen_menu.tscn")

func _ready() -> void:
	SettingsMp.server_tick_rate = server_tick_rate
	#print(OS.get_cmdline_args())
	if OS.get_cmdline_args()[1] == "host":
		#print("spawning server...")
		var server := SERVER_WRAPPER.instantiate()
		add_child(server)
		SignalBusMp.setup_settings_toggle.emit(SettingsMp.MP_PROCESS_TYPE.MP_SERVER)
	elif OS.get_cmdline_args()[1] == "client":
		#print("spawning client...")
		#var client := CLIENT_WRAPPER.instantiate()
		var client := CLIENT_WRAPPER.instantiate()
		add_child(client)
		SignalBusMp.setup_settings_toggle.emit(SettingsMp.MP_PROCESS_TYPE.MP_CLIENT)
		
