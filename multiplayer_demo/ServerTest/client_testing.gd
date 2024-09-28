extends Node2D

func _ready() -> void:
	#multiplayer
	#get_tree().get_multiplayer()
	var e_client := ENetMultiplayerPeer.new()
	e_client.create_client("127.0.0.1", 12345)
	multiplayer.multiplayer_peer = e_client
