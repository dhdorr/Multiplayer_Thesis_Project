class_name Connection_Manager_Server extends Node


@onready var e_server := UDPServer.new()
@export var dest_port : int = 0
@onready var world_state_manager_s: World_State_Manager = %World_State_Manager_S

var _server_state : int

var peers : Array[PacketPeerUDP]


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
		match typeof(packet):
			TYPE_DICTIONARY:
				# need to verify packet here #
				if packet["version"] != SettingsMp.protocol_version:
					print("invalid packet version: ", packet["version"])
					return
				# -------------------------- #
				if packet["passcode"] == "hello, world!":
					_accept_new_peer_connection_3D(peer)
					
					print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
					print("Received data: %s" % [packet])
					
					SignalBusMp.update_peer_count.emit(peers.size())
					
					_update_lobby_to_clients()


# Disable if not using 3D #
func _accept_new_peer_connection_3D(peer : PacketPeerUDP) -> void:
	# confirm connection
	peers.append(peer)
	
	var player_id : int = peers.size()
	world_state_manager_s.init_player_positions_3D(player_id)
	
	var init_position : Vector3 = world_state_manager_s.server_player_dict[player_id].position
	var init_rotation : Vector3 = world_state_manager_s.server_player_dict[player_id].rotation
	
	#var packet_interface := SERVER_PACKET_INTERFACE.player_initialization_response.new(player_id, init_position, init_rotation)
	var interface := SERVER_PACKET_INTERFACE.Connection_Response.new(player_id, init_position, init_rotation)
	var response : Dictionary = interface._to_dictionary()
	#var response : Dictionary = { "init": packet_dict }
	print(response)
	
	%Network_Layer_S.simulate_sending_packet_over_network(peer, response)
# ----------------------- #

func send_world_state_updates_to_clients_2(world_state : Dictionary) -> void:
	for peer in peers:
		#peer.join_multicast_group("asdf", "d")
		%Network_Layer_S.simulate_sending_update_over_network_2(peer, world_state)


func _receive_client_input_packets() -> void:
	for peer in peers:
		if peer.get_available_packet_count() > 0:
			var packet = peer.get_var()
			
			match typeof(packet):
				TYPE_DICTIONARY:
					# pass to world state manager
					world_state_manager_s.get_input_dict(packet)


func _update_lobby_to_clients() -> void:
	var lobby_state_dict : Dictionary = { "lobby_state": {} }
	#var status_dict : Dictionary = { "status": SettingsMp.GLOBAL_LOBBY_STATUS.OPEN }
	var players_dict : Dictionary = {}
	for player_id in world_state_manager_s.server_player_dict.keys():
		var player : CharacterBody3D = world_state_manager_s.server_player_dict[player_id]
		var player_orientation_dict : Dictionary = {}
		player_orientation_dict["position"] = player.position
		player_orientation_dict["rotation"] = player.rotation
		players_dict[player_id] = player_orientation_dict
	
	lobby_state_dict["lobby_state"]["status"] = SettingsMp.GLOBAL_LOBBY_STATUS.OPEN
	lobby_state_dict["lobby_state"]["players"] = players_dict
	
	print("Server side lobby state:")
	print(lobby_state_dict)
	
	send_world_state_updates_to_clients_2(lobby_state_dict)


func start_match_on_clients() -> void:
	var lobby_state_dict : Dictionary = { "lobby_state": {} }
	#var status_dict : Dictionary = { "status": SettingsMp.GLOBAL_LOBBY_STATUS.START_MATCH }
	lobby_state_dict["lobby_state"]["status"] = SettingsMp.GLOBAL_LOBBY_STATUS.START_MATCH
	send_world_state_updates_to_clients_2(lobby_state_dict)


func poll_server() -> void:
	e_server.poll()

func listen_for_new_connections() -> void:
	_check_for_new_client_connections()

func listen_for_client_input_packets() -> void:
	_receive_client_input_packets()
