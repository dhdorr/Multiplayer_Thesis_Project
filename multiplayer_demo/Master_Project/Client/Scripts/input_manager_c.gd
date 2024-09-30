class_name Input_Manager_Client extends Node

var direction : Vector2
var input_buffer : Array[Vector2]


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	input_buffer.append(direction)
	
