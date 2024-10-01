extends Node

var network_latency_ms := 100.0


func simulate_sending_input_over_network(client: PacketPeerUDP, content: Dictionary) -> void:
	get_tree().create_timer(network_latency_ms / 1000).timeout.connect(
		func() -> void:
			client.put_var(content)
	)

func simulate_send_string_over_network(client: PacketPeerUDP, content: PackedByteArray) -> void:
	get_tree().create_timer(network_latency_ms / 1000).timeout.connect(
		func() -> void:
			client.put_var(content)
	)
