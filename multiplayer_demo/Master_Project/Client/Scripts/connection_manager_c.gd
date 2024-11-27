class_name Connection_Manager_Client extends Node

@onready var buffer_manager_c: Buffer_Manager_C = %Buffer_Manager_C
#@onready var input_manager_c: Input_Manager_Client
@onready var ghost_manager_c: Ghost_Manager_C = %Ghost_Manager_C
@onready var packet_manager_c: PACKET_MANAGER_C = $"../Packet_Manager_C"

var e_client := PacketPeerUDP.new()

var connected := false
var test_connected := false
var pending := false

var player_id : int = 0

#var packet_interface := CLIENT_PACKET_INTERFACE.new()


#func _ready() -> void:
	#var my_id : int = randi_range(0,10)
	#e_client.bind(5000+my_id, "127.0.0.1")
	#e_client.connect_to_host("127.0.0.1", 12345)
	
	
func _connect_to_server() -> Error:
	_update_client_state(Client_Wrapper.CLIENT_STATE_TYPES.CONNECTING_TO_SERVER)
	
	var my_id : int = randi_range(0,10)
	e_client.bind(5000+my_id, SettingsMp.server_ip_address)
	e_client.connect_to_host(SettingsMp.server_ip_address, 12345)
	
	# Try to contact server
	# packet manager creates connection string packet with relevant information
	var packet : Dictionary = packet_manager_c.create_connection_string_packet()
	var put_packet_error := e_client.put_var(packet)
	
	if put_packet_error != OK:
		print_debug(put_packet_error)
		return put_packet_error
	pending = true
	
	return put_packet_error

func send_connection_string() -> void:
	%Network_Layer_C.simulate_send_string_over_network(e_client, "hello, world!".to_utf8_buffer())

func send_input(input_dict : Dictionary) -> void:
	%Network_Layer_C.simulate_sending_input_over_network(e_client, input_dict)

func send_input_3D(packet: Dictionary) -> void:
	%Network_Layer_C.simulate_sending_input_over_network_3D(e_client, packet)


func send_ready_up_to_server(is_ready : bool) -> void:
	print("user: %s , is ready? %s" % [SettingsMp.client_username, is_ready])
	var interface := CLIENT_PACKET_INTERFACE.Lobby_Ready_Up.new(is_ready, player_id)
	send_input_3D(interface._to_dictionary())


func listen_for_connection_packets() -> void:
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		var is_valid_packet : bool = packet_manager_c.validate_packet(packet, SettingsMp.SERVER_PACKET_TYPES.CONNECTION_RESPONSE)
		if !connected and is_valid_packet:
			var packet_dict : Dictionary = packet
			_handle_connection_response(packet_dict)
		else:
			print("invalid connection response packet: ", packet)


func listen_for_lobby_packets() -> void:
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		if packet_manager_c.validate_packet(packet, SettingsMp.SERVER_PACKET_TYPES.LOBBY_UPDATE):
			_handle_lobby_packets(packet)
		else:
			print("invalid lobby update packet")


func listen_for_world_state_packets() -> void:
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		if packet_manager_c.validate_packet(packet, SettingsMp.SERVER_PACKET_TYPES.WORLD_STATE_UPDATE):
			_handle_world_state_response(packet)
		else:
			print("invalid world state update packet: ", packet)


func _handle_lobby_packets(packet: Dictionary) -> void:
	var lobby_players_list : Array[Dictionary] = packet["list_of_players"]
	# goes to lobby ui
	SignalBusMp.update_client_lobby.emit(lobby_players_list.duplicate())
	
	# possibly make a lobby manager instead?
	var is_new_ghost_added : bool = ghost_manager_c.add_new_ghost(lobby_players_list)
	#if is_new_ghost_added:
		# bubble up some signals that updates client lobby ui
	
	# this is why I think I need a lobby manager now
	var lobby_status = packet["lobby_status"]
	if lobby_status == SettingsMp.GLOBAL_LOBBY_STATUS.START_MATCH:
		# send a signal to start the countdown to begin the match
		_update_client_state(Client_Wrapper.CLIENT_STATE_TYPES.STARTING_MATCH)
		return


func _handle_world_state_response(packet: Dictionary) -> void:
	buffer_manager_c.buffer_world_state_packet(packet)


# receive connection response packet from the server and parse it
# save the server's authoritative initial orientation for the player
# update the client wrapper's state to waiting for lobby
func _handle_connection_response(packet: Dictionary) -> void:
	print("Connected: %s" % packet)
	connected = true
	pending = false
	
	# unpack the response packet
	player_id = packet["player_init_data"]["player_id"]
	SignalBusMp.player_id_received.emit(player_id)
	
	var init_position : Vector3 = packet["player_init_data"]["position"]
	var init_rotation: Vector3 = packet["player_init_data"]["rotation"]
	
	SettingsMp.init_player_orientation_3D(init_position, init_rotation)
	
	_update_client_state(Client_Wrapper.CLIENT_STATE_TYPES.WAITING_IN_LOBBY)
	
	SignalBusMp.update_client_label.emit(player_id)


func _update_client_state(state: int):
	SignalBusMp.update_client_state.emit(state)
