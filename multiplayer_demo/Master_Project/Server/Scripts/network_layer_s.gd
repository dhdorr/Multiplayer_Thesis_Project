extends Node

var network_latency_ms := 50.0

func simulate_sending_packet_over_network(peer: PacketPeerUDP, content: PackedByteArray) -> void:
	get_tree().create_timer(network_latency_ms / 1000).timeout.connect(
		func() -> void:
			peer.put_var(content)
	)
	
func simulate_sending_update_over_network(peer: PacketPeerUDP, content: Vector2) -> void:
	get_tree().create_timer(network_latency_ms / 1000).timeout.connect(
		func() -> void:
			peer.put_var(content)
	)
	