extends Node2D

@onready var client_player: PlayerClient = %Client_Player
@onready var server_player: PlayerServer = %Server_Player

func _physics_process(delta: float) -> void:
	set_physics_process(false)
	
	get_tree().create_timer(1.0).timeout.connect(func() -> void:
		set_physics_process(true)
		print("client: ", client_player.position)
		print("server: ", server_player.position)
	)
	
