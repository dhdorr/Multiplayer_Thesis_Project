extends Node
## Network latency in miliseconds
@export_range(0.0, 300.0, 0.1) var network_latency := 50.0


func simulate_network(buff : Array[Vector2]) -> void:
	#var temp : Array[Vector2]
	#temp.append_array(buff)
	
	get_tree().create_timer(network_latency / 1000.0).timeout.connect(func() -> void:
		SignalBus.deliver_to_server.emit(buff.duplicate())
	)
	
