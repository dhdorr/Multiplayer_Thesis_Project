class_name ClientInputDevice extends RefCounted


class InputDevice extends Node:
	
	signal send_input_to_server
	signal send_input_to_client
	signal server_response_to_client
	
	var client_input : Vector2 = Vector2.ZERO
	var network_latency := 0.1
	var input_buffer_delay := 0.016

	func _physics_process(delta: float) -> void:
		client_input = Input.get_vector("move_left","move_right","move_up","move_down")
		send_input_to_client.emit(client_input)
		_input_delay(input_buffer_delay)
		_transmit_input()
	
	## Delay inputs for some duration of time (50ms)
	func _input_delay(delay: float) -> void:
		#print(delay)
		set_physics_process(false)
		get_tree().create_timer(delay).timeout.connect(set_physics_process.bind(true))

	## Simulate sending client input over the wire to the server
	func _transmit_input() -> void:
		var test_input := client_input
		get_tree().create_timer(network_latency).timeout.connect(func() -> void:
			send_input_to_server.emit(test_input)
		)
	
	
	func respond_to_client(player: Dictionary) -> void:
		get_tree().create_timer(network_latency).timeout.connect(func() -> void:
			server_response_to_client.emit(player)
		)
		
