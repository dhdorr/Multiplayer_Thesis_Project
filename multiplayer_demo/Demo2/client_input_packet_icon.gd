extends Node2D

@onready var frame_line_marker_2d: Marker2D = %Frame_Line_Marker2D


func set_up_packet(num : float) -> void:

	var frame_width : float = 0.0
	if Settings.input_delay == 0.0:
		frame_width = num / Settings.max_fps
	else:
		frame_width = num / (Settings.max_fps / Settings.input_delay)
	
	frame_line_marker_2d.position.x = frame_width / 2.0

	var tween := get_tree().create_tween().tween_property(self, "position:x", num, 1.0)
	tween.finished.connect(self.queue_free)