extends Node2D


func set_up_network_packet(num: float, y_pos : float) -> void:
	# scale width of frame with transmission delay
	var frame_width : float = 0.0
	if Settings.transmission_delay == 0.0:
		frame_width = num / (Settings.max_fps * Settings.client_tick_rate_factor)
	else:
		# logic may be wrong here...
		frame_width = num / ((Settings.max_fps * Settings.client_tick_rate_factor) / Settings.transmission_delay)
	
	# move left the difference between the original size and the new size
	# the distance a frame travels in one frame old - new
	var delta_x : float = (Settings.time_line_length / Settings.max_fps) - frame_width
	var spawn_x : float = self.position.x - delta_x
	#var travel_x : float = self.position.x - (50.0 * (Settings.client_tick_rate_factor - 1.0))
	self.position = self.position.move_toward(Vector2(spawn_x, self.position.y), 1000.0)
	var imaginary_server_buffer : float = 3.0 / (Settings.max_fps * Settings.client_tick_rate_factor)
	var travel_x : float = self.position.x + num * (Settings.get_network_latency_seconds())
	var travel_y : float = y_pos
	var tween := get_tree().create_tween()
	#tween.tween_property(self, "position:x", position.x + travel_x, Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	#tween.parallel().tween_property(self, "position:y", position.y + demo_2_server_graph.position.y, Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	tween.tween_property(self, "position", Vector2(travel_x, travel_y), Settings.get_network_latency_seconds())
	tween.finished.connect(self.queue_free)
