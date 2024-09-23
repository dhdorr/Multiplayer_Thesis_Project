extends Node2D

#@onready var frame_line_marker_2d: Marker2D = %Frame_Line_Marker2D
@onready var label: Label = %Label


func set_up_packet(num : float, counter : int) -> void:
	#label.text = str(counter)
	#
	## scale width of frame with transmission delay
	#var frame_width : float = 0.0
	#frame_width = num / (Settings.max_fps)
	#var frame_offset : float = 0.0
	#if Settings.transmission_delay == 0.0:
		#frame_offset = num / (Settings.max_fps * Settings.client_tick_rate_factor)
	#else:
		#frame_offset = num / ((Settings.max_fps * Settings.client_tick_rate_factor) / Settings.transmission_delay)
	#
	## move left the difference between the original size and the new size
	## the distance a frame travels in one frame old - new
	#var delta_x : float = (Settings.time_line_length / Settings.max_fps) - frame_offset
	#var travel_x : float = self.position.x - delta_x
	##var travel_x : float = self.position.x - (50.0 * (Settings.client_tick_rate_factor - 1.0))
	#self.position = self.position.move_toward(Vector2(travel_x, self.position.y), 100.0)
	
	#frame_line_marker_2d.position.x = 8.0 + frame_width / 2.0

	var tween := get_tree().create_tween().tween_property(self, "position:x", num, 1.0)
	
	tween.finished.connect(self.queue_free)
