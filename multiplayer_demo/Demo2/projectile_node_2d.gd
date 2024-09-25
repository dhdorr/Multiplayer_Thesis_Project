extends Node2D

func _physics_process(delta: float) -> void:
	position.y -= 505.0 * delta
	
	if position.y < -100.0:
		queue_free()
