extends Node2D

func set_up_network_packet(num: float) -> void:
	var travel_x := num * (Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position:x", position.x + travel_x, Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	tween.parallel().tween_property(self, "position:y", position.y + 180.0, Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	
	tween.finished.connect(self.queue_free)
