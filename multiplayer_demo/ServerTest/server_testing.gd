extends Node2D

func _ready() -> void:
	#multiplayer
	#get_tree().get_multiplayer()
	#var e_server := ENetMultiplayerPeer.new()
	#e_server.create_server(12345, 1)
	#multiplayer.multiplayer_peer = e_server
	print(OS.get_cmdline_args())
	if OS.get_cmdline_args()[1] == "host":
		var e_server := ENetMultiplayerPeer.new()
		e_server.create_server(12345, 1)
		multiplayer.multiplayer_peer = e_server
		print("server started")
		print(multiplayer.peer_connected.connect(testme))
	elif OS.get_cmdline_args()[1] == "client":
		var e_client := ENetMultiplayerPeer.new()
		
		e_client.create_client("127.0.0.1", 12345)
		multiplayer.multiplayer_peer = e_client
		
		multiplayer.connected_to_server.connect(func() -> void: print("client connected"))
		print("client's generated id: ", e_client.get_unique_id())

func testme(test : int) -> void:
	print(test)
