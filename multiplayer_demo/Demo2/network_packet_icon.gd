extends Node2D


func set_up_network_packet(num: float, y_pos : float) -> void:
	var travel_x := position.x + num * (Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	var travel_y : float = y_pos
	var tween := get_tree().create_tween()
	#tween.tween_property(self, "position:x", position.x + travel_x, Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	#tween.parallel().tween_property(self, "position:y", position.y + demo_2_server_graph.position.y, Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	tween.tween_property(self, "position", Vector2(travel_x, travel_y), Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	tween.finished.connect(self.queue_free)
