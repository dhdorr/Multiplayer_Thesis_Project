extends Node


@onready var e_server := UDPServer.new()
@onready var world_state_manager_s: Node = %World_State_Manager_S

var peers : Array[PacketPeerUDP]

func _ready() -> void:
	start_server()


func start_server() -> void:
	e_server.listen(12345)
	print("Server started on port: ", 12345)


func check_for_new_client_connections() -> void:
	if e_server.is_connection_available():
		var peer : PacketPeerUDP = e_server.take_connection()
		var packet = peer.get_packet()
		match typeof(packet):
			TYPE_PACKED_BYTE_ARRAY:
				print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
				print("Received data: %s" % [packet.get_string_from_utf8()])
		# confirm connection
		var response : PackedByteArray = "welcome!".to_utf8_buffer()
		%Network_Layer_S.simulate_sending_packet_over_network(peer, response)
		peers.append(peer)


func send_world_state_updates_to_clients(world_state : Vector2) -> void:
	for peer in peers:
		%Network_Layer_S.simulate_sending_update_over_network(peer, world_state)
		
func send_world_state_updates_to_clients_2(world_state : Dictionary) -> void:
	for peer in peers:
		%Network_Layer_S.simulate_sending_update_over_network_2(peer, world_state[1])


func receive_client_input_packets() -> void:
	for peer in peers:
		if peer.get_available_packet_count() > 0:
			var packet = peer.get_var()
			match typeof(packet):
				TYPE_VECTOR2:
					# pass to world state manager
					world_state_manager_s.get_input(packet)
				TYPE_DICTIONARY:
					# pass to world state manager
					world_state_manager_s.get_input_2(packet)
				TYPE_PACKED_BYTE_ARRAY:
					break


func _process(delta: float) -> void:
	e_server.poll()
	check_for_new_client_connections()


func _physics_process(delta: float) -> void:
	#send_world_state_updates_to_clients()
	receive_client_input_packets()
