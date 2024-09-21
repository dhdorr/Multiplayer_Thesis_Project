extends Node2D

@onready var input_manager: Node = %Input_Manager
@onready var demo_2_player_client: CharacterBody2D = %Demo2_Player_Client


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# ACTING AS SIGNAL BUS
	input_manager.dump_input_buffer.connect(demo_2_player_client.consume_input_buffer)
	# can connect same signal to multiple places


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
