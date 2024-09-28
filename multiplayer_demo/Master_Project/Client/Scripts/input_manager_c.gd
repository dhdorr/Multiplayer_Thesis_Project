extends Node

var direction : Vector2
var input_buffer : Array[Vector2]

@onready var player: CharacterBody2D = %Player
@onready var connection_manager_c: Node = %Connection_Manager_C

func _physics_process(delta: float) -> void:
	#if input_buffer.size() > 0:
		#input_buffer.pop_front()
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	input_buffer.append(direction)
	
	player.get_input(direction)
	connection_manager_c.get_input(direction)
