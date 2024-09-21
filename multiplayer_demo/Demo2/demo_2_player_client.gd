extends CharacterBody2D

@onready var input_manager: Node = %Input_Manager

var player_input_buffer :Array[Vector2]

func _ready() -> void:
	pass
	#input_manager.dump_inputs.connect(consume_input_buffer)

func _physics_process(delta: float) -> void:
	# can simulate many frames of movement in one physics process frame
	# by using a for loop and calling move and slide each iteration.
	for i in player_input_buffer:
		velocity = velocity.move_toward(i * 300.0, delta * 1600)
		move_and_slide()
	player_input_buffer.clear()

func consume_input_buffer(recv_buff: Array[Vector2]) -> void:
	player_input_buffer = recv_buff
