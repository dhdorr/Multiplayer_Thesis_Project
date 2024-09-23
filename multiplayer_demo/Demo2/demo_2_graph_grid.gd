extends Node2D

@onready var grid_line := preload("res://Demo2/grid_line_marker_2d.tscn")

func _ready() -> void:
	for i in range(18):
		var temp : Marker2D = grid_line.instantiate()
		add_child(temp)
		temp.position = Vector2(self.position.x + (64.0 * i), self.position.y)
		var tween := get_tree().create_tween()
		tween.tween_property(temp, "position:x", 3840.0 + temp.position.x, 1.0)
		tween.finished.connect(temp.queue_free)

func _physics_process(delta: float) -> void:
	var temp : Marker2D = grid_line.instantiate()
	add_child(temp)
	temp.position = self.position
	move_grid(temp)
	

func move_grid(marker : Marker2D) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(marker, "position:x", 3840.0, 1.0)
	tween.finished.connect(marker.queue_free)
