extends Node


func simulate_network(buff : Array[Vector2]) -> void:
	
	get_tree().create_timer(Settings.get_network_latency_seconds()).timeout.connect(func() -> void:
		SignalBus.deliver_to_server.emit(buff.duplicate())
	)
	
