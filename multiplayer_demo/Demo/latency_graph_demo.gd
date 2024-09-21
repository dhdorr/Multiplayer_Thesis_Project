extends Node2D

@onready var client_player: PlayerClient = %Client_Player
@onready var server_player: PlayerServer = %Server_Player


func _ready() -> void:
	# Signal BUS?
	server_player.input_device.server_response_to_client.connect(client_player._test_process_server_response)
