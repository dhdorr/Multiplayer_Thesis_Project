class_name ClientInputDevice extends RefCounted


class InputDevice extends Node:
	
	#signal client_input_given(client_input: Vector2)
	
	var client_input : Vector2 = Vector2.ZERO


	func _physics_process(delta: float) -> void:
		client_input = Input.get_vector("move_left","move_right","move_up","move_down")
		
		
