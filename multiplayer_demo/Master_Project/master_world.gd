extends Node

const CLIENT_WRAPPER = preload("res://Master_Project/Client/Scenes/client_wrapper.tscn")
const SERVER_WRAPPER = preload("res://Master_Project/Server/Scenes/server_wrapper.tscn")
const START_SCREEN_MENU = preload("res://Master_Project/Client/Scenes/start_screen_menu.tscn")

func _ready() -> void:
	#print(OS.get_cmdline_args())
	if OS.get_cmdline_args()[1] == "host":
		#print("spawning server...")
		var server := SERVER_WRAPPER.instantiate()
		add_child(server)
	elif OS.get_cmdline_args()[1] == "client":
		#print("spawning client...")
		#var client := CLIENT_WRAPPER.instantiate()
		var client := CLIENT_WRAPPER.instantiate()
		add_child(client)
		
