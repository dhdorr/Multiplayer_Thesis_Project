extends Node

var network_latency_ms := 100.0


func simulate_sending_input_over_network(client: PacketPeerUDP, content: Dictionary) -> void:
	get_tree().create_timer(network_latency_ms / 1000).timeout.connect(
		func() -> void:
			client.put_var(content)
	)

func simulate_sending_input_over_network_3D(client: PacketPeerUDP, packet: Dictionary) -> void:
	get_tree().create_timer(network_latency_ms / 1000).timeout.connect(
		func() -> void:
			#var packet_dict : Dictionary = { "player_id": packet._player_id, "packet_id": packet._packet_id, "input_vector": packet._input_vector }
			client.put_var(packet)
	)

func simulate_send_string_over_network(client: PacketPeerUDP, content: PackedByteArray) -> void:
	get_tree().create_timer(network_latency_ms / 1000).timeout.connect(
		func() -> void:
			client.put_var(content)
	)
