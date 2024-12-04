class_name Connection_Manager_Server extends Node


@onready var e_server := UDPServer.new()
@export var dest_port : int = 0
@onready var world_state_manager_s: World_State_Manager = %World_State_Manager_S
@onready var packet_manager_s: Packet_Manager_S = %Packet_Manager_S
@onready var lobby_manager_s: LOBBY_MANAGER_S = %Lobby_Manager_S

var _server_state : int

var peers : Array[PacketPeerUDP]
var curr_match_id : int

func start_server() -> bool:
	var err = e_server.listen(12345)
	if err != OK:
		print(err)
		return false
	
	print("Server started on port: ", 12345)
	return true


func _check_for_new_client_connections() -> void:
	if e_server.is_connection_available():
		var peer : PacketPeerUDP = e_server.take_connection()
		
		var packet = peer.get_var()
		
		if packet_manager_s.validate_packet(packet, SettingsMp.CLIENT_PACKET_TYPES.CONNECTION_REQUEST, "hello, world!"):
			# confirm connection
			peers.append(peer)
			
			var store_me : Dictionary = { "player_ip" = peer.get_packet_ip(), "player_port" = peer.get_packet_port(), "username" = packet["username"] }
			
			var real_player_id : int = $"../Database_Manager".create_new_player(store_me)
			
			# add new player to the lobby and update the whole lobby
			lobby_manager_s.add_new_player_to_lobby(packet["username"], packet["skin_id"], real_player_id)
			
			_accept_new_peer_connection_3D(peer, real_player_id)
			#var store_me : Dictionary = { "player_ip" = peer.get_packet_ip(), "player_port" = peer.get_packet_port(), "username" = packet["username"] }
			#var real_player_id : int = $"../Database_Manager".create_new_player(store_me)
			$"../Database_Manager".add_player_to_match(curr_match_id, real_player_id)
			print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
			print("Received data: %s" % [packet])
			
			SignalBusMp.update_peer_count.emit(peers.size())
			


# create and init the new player, then respond to that player
func _accept_new_peer_connection_3D(peer : PacketPeerUDP, player_id : int) -> void:
	var player_orientation : Array[Vector3] = world_state_manager_s.init_player_positions_3D(player_id)
	
	var init_position : Vector3 = world_state_manager_s.server_player_dict[player_id].position
	var init_rotation : Vector3 = world_state_manager_s.server_player_dict[player_id].rotation
	
	var interface := SERVER_PACKET_INTERFACE.Connection_Response.new(player_id, init_position, init_rotation)
	var response : Dictionary = interface._to_dictionary()
	
	# let client know they are connected
	%Network_Layer_S.simulate_sending_packet_over_network(peer, response)
# ----------------------- #


func receive_client_ready_up() -> void:
	for peer in peers:
		if peer.get_available_packet_count() > 0:
			var packet = peer.get_var()
			if packet_manager_s.validate_packet(packet, SettingsMp.CLIENT_PACKET_TYPES.LOBBY_READY_UP):
				if not packet.has("is_ready"):
					print("no ready status provided >:(")
					print(packet)
					return
				lobby_manager_s.update_lobby_player_status(packet["player_id"], packet["is_ready"])


func send_world_state_updates_to_clients_2(world_state : Dictionary) -> void:
	for peer in peers:
		#peer.join_multicast_group("asdf", "d")
		%Network_Layer_S.simulate_sending_update_over_network_2(peer, world_state)


func send_world_state_updates_to_clients_actual(world_state : Dictionary) -> void:
	$"../Database_Manager".write_server_world_update_to_table(world_state)
	for peer in peers:
		#peer.join_multicast_group("asdf", "d")
		%Network_Layer_S.simulate_sending_update_over_network_2(peer, world_state)


func _handle_client_input_packet(packet: Dictionary) -> void:
	world_state_manager_s.register_player_input(packet)


func update_lobby_to_clients(lobby_update : Dictionary) -> void:
	print("Server side lobby state:")
	print(lobby_update)
	
	send_world_state_updates_to_clients_2(lobby_update)


func poll_server() -> void:
	e_server.poll()

func listen_for_new_connections() -> void:
	_check_for_new_client_connections()

func listen_for_client_ready_ups() -> void:
	receive_client_ready_up()

func listen_for_client_input_packets() -> void:
	for peer in peers:
		if peer.get_available_packet_count() > 0:
			var packet = peer.get_var()
			if packet_manager_s.validate_packet(packet, SettingsMp.CLIENT_PACKET_TYPES.INPUT_PACKET):
				$"../Database_Manager".write_client_packet_to_table(packet)
				_handle_client_input_packet(packet)
				
