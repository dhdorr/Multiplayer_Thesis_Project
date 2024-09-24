extends Node2D

func _physics_process(delta: float) -> void:
	position.y -= 505 * delta
