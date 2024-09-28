extends Node

const CLIENT_WRAPPER = preload("res://Master_Project/Client/Scenes/client_wrapper.tscn")
const SERVER_WRAPPER = preload("res://Master_Project/Server/Scenes/server_wrapper.tscn")

func _ready() -> void:
	print(OS.get_cmdline_args())
	if OS.get_cmdline_args()[1] == "host":
		print("spawning server")
		var server := SERVER_WRAPPER.instantiate()
		add_child(server)
		#var e_server := ENetMultiplayerPeer.new()
		#e_server.create_server(12345, 1)
		#multiplayer.multiplayer_peer = e_server
		#print("server started")
		#print(multiplayer.peer_connected.connect(testme))
	elif OS.get_cmdline_args()[1] == "client":
		print("spawning client...")
		var client := CLIENT_WRAPPER.instantiate()
		add_child(client)
		
		#var e_client := ENetMultiplayerPeer.new()
		#e_client.create_client("127.0.0.1", 12345)
		#multiplayer.multiplayer_peer = e_client
		#
		#multiplayer.connected_to_server.connect(func() -> void: print("client connected"))
		#print("client's generated id: ", e_client.get_unique_id())

#func testme(test : int) -> void:
	#print(test)
