extends Node


@onready var e_server := UDPServer.new()

var peers : Array[PacketPeerUDP]

func _ready() -> void:
	start_server()


func start_server() -> void:
	e_server.listen(12345)


func check_for_new_client_connections() -> void:
	if e_server.is_connection_available():
		var peer : PacketPeerUDP = e_server.take_connection()
		var packet := peer.get_packet()
		print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
		print("Received data: %s" % [packet.get_string_from_utf8()])
		
		var response : PackedByteArray = "welcome!".to_utf8_buffer()
		#peer.put_packet(response)
		# confirm connection
		%Network_Layer_S.simulate_sending_packet_over_network(peer, response)
		peers.append(peer)


func send_world_state_updates_to_clients() -> void:
	for peer in peers:
		%Network_Layer_S.simulate_sending_packet_over_network(peer, "take this update!".to_utf8_buffer())
		#peer.put_packet("take this update!".to_utf8_buffer())


func receive_client_input_packets() -> void:
	for peer in peers:
		if peer.get_available_packet_count() > 0:
			var packet = peer.get_var()
			match typeof(packet):
				TYPE_VECTOR2:
					print("vector: ", packet)
				TYPE_PACKED_BYTE_ARRAY:
					break
					print(packet.get_string_from_utf8())
					#print("String Received: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
					#print(peers.size())


func _process(delta: float) -> void:
	e_server.poll()
	check_for_new_client_connections()


func _physics_process(delta: float) -> void:
	#send_world_state_updates_to_clients()
	receive_client_input_packets()
