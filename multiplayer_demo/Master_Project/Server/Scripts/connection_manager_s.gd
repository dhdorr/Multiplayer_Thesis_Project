class_name Connection_Manager_Server extends Node
#
#
@onready var e_server := UDPServer.new()
@export var dest_port : int = 0
@onready var world_state_manager_s: World_State_Manager = %World_State_Manager_S
#
#
var peers : Array[PacketPeerUDP]


#
func _ready() -> void:
	start_server()
#
#
func start_server() -> void:
	e_server.listen(12345)
	print("Server started on port: ", 12345)

#func _process(delta):
	#e_server.poll() # Important!
	#if e_server.is_connection_available():
		#var peer: PacketPeerUDP = e_server.take_connection()
		#var packet = peer.get_packet()
		#print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
		#print("Received data: %s" % [packet.get_string_from_utf8()])
		## Reply so it knows we received the message.
		#var put_packet_error := peer.put_packet(packet)
		#if put_packet_error != OK:
			#print_debug(put_packet_error)
		## Keep a reference so we can keep contacting the remote peer.
		#peers.append(peer)


func check_for_new_client_connections() -> void:
	if e_server.is_connection_available():
		# max peer count
		if peers.size() == 2:
			return
		var peer : PacketPeerUDP = e_server.take_connection()
		var packet = peer.get_packet()
		match typeof(packet):
			TYPE_PACKED_BYTE_ARRAY:
				var connection_string : String = packet.get_string_from_utf8()
				if connection_string == "hello, world!":
					#_accept_new_peer_connection(peer)
					_accept_new_peer_connection_3D(peer)
					print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
					print("Received data: %s" % [packet.get_string_from_utf8()])


func _accept_new_peer_connection(peer : PacketPeerUDP) -> void:
	# confirm connection
	peers.append(peer)
	var player_init_dict : Dictionary = {"player_id": peers.size(), "position": Vector2((peers.size() - 1) * 64.0 * 3.0 + 64.0, 100.0)}
	print(player_init_dict)
	var response : Dictionary = {"init": player_init_dict}
	world_state_manager_s.init_player_positions(player_init_dict)
	%Network_Layer_S.simulate_sending_packet_over_network(peer, response)
	

# Disable if not using 3D #
func _accept_new_peer_connection_3D(peer : PacketPeerUDP) -> void:
	# confirm connection
	peers.append(peer)
	var init_position := Vector3.ZERO
	init_position = Vector3(0.0, 0.0, float(peers.size() - 1) * 3.0)
	var player_init_dict : Dictionary = {"player_id": peers.size(), "position": init_position}
	print(player_init_dict)
	var response : Dictionary = {"init": player_init_dict}
	world_state_manager_s.init_player_positions_3D(player_init_dict)
	%Network_Layer_S.simulate_sending_packet_over_network(peer, response)
# ----------------------- #

func send_world_state_updates_to_clients_2(world_state : Dictionary) -> void:
	for peer in peers:
		%Network_Layer_S.simulate_sending_update_over_network_2(peer, world_state)


func receive_client_input_packets() -> void:
	for peer in peers:
		if peer.get_available_packet_count() > 0:
			var packet = peer.get_var()
			match typeof(packet):
				TYPE_DICTIONARY:
					# pass to world state manager
					world_state_manager_s.get_input_dict(packet)


func _process(delta: float) -> void:
	e_server.poll()
	check_for_new_client_connections()
	


func _physics_process(delta: float) -> void:
	receive_client_input_packets()
	#send_world_state_updates_to_clients()
	
