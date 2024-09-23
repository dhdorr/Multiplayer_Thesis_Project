extends Node


func simulate_network(buff : Array[Vector2]) -> void:
	SignalBus.spawn_client_graph_network_packet.emit(buff.duplicate())
	get_tree().create_timer(Settings.get_network_latency_seconds()).timeout.connect(func() -> void:
		SignalBus.transmit_input_buffer_to_server.emit(buff.duplicate())
	)
	
