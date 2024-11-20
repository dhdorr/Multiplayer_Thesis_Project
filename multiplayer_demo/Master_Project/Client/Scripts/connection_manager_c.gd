class_name Connection_Manager_Client extends Node

@onready var buffer_manager_c: Buffer_Manager_C = %Buffer_Manager_C
#@onready var input_manager_c: Input_Manager_Client
@onready var ghost_manager_c: Ghost_Manager_C = %Ghost_Manager_C

var e_client := PacketPeerUDP.new()

var connected := false
var test_connected := false
var pending := false

var player_id : int = 0

#var packet_interface := CLIENT_PACKET_INTERFACE.new()


func _ready() -> void:
	var my_id : int = randi_range(0,10)
	e_client.bind(5000+my_id, "127.0.0.1")
	e_client.connect_to_host("127.0.0.1", 12345)
	
	
func _connect_to_server() -> Error:
	_update_client_state(Client_Wrapper.CLIENT_STATE_TYPES.CONNECTING_TO_SERVER)
	# Try to contact server
	var put_packet_error := e_client.put_packet("hello, world!".to_utf8_buffer())
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


#func _physics_process(delta: float) -> void:
	#if e_client.get_available_packet_count() > 0:
		#var packet = e_client.get_var()
		#if !connected:
			#_handle_connection_response(packet)
		#else:
			#_handle_world_state_response(packet)


func listen_for_connection_packets() -> void:
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		if !connected:
			_handle_connection_response(packet)


func listen_for_lobby_packets() -> void:
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		_handle_lobby_packets(packet)


func listen_for_world_state_packets() -> void:
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		_handle_world_state_response(packet)


func _handle_lobby_packets(packet: Variant) -> void:
	match typeof(packet):
		TYPE_DICTIONARY:
			# var players_dict : Dictionary = { 1: { "position": Vector3.ZERO, "rotation": Vector3.ZERO }, 2: { "position": Vector3.ZERO, "rotation": Vector3.ZERO } }
			# var lobby_state_dict : Dictionary = {}
			# lobby_state_dict["players"] = players_dict
			# lobby_state_dict["count"] = 2
			
			# TODO do something with the packet...
			# these are lobby packets so maybe load in other player's ghosts
			# display nameplates or lobby count updates or something
			
			# { "lobby_state" : key=String, val=Dictionary
			#		{ key=String, val=Variant
			# 			"players": { key=int, val=Dictionary
			# 				1 : { "position" : 0, "rotation" : 0 },
			# 				2 : { "position" : 1, "rotation" : 1 },
			#			},
			#			"count": 2,
			#			"status": "closed",
			#		},
			# } 
			
			if not packet.has("lobby_state"):
				print("packet does not match lobby interface: ")
				print(packet)
				return
			
			# this is why I think I need a lobby manager now
			var lobby_status = packet["lobby_state"]["status"]
			if lobby_status == SettingsMp.GLOBAL_LOBBY_STATUS.START_MATCH:
				# send a signal to start the countdown to begin the match
				print("start match")
				_update_client_state(Client_Wrapper.CLIENT_STATE_TYPES.STARTING_MATCH)
				return
			
			var lobby_players_dict = packet["lobby_state"]["players"]
			# possibly make a lobby manager instead?
			var is_new_ghost_added : bool = ghost_manager_c.add_new_ghost(lobby_players_dict)
			if is_new_ghost_added:
				# bubble up some signals that updates client lobby ui
				print("new ghost added")


func _handle_world_state_response(packet: Variant) -> void:
	match typeof(packet):
		TYPE_DICTIONARY:
			if buffer_manager_c.waiting_for_first_packet:
				buffer_manager_c.start_buffer_on_receipt(packet)
			else:
				# Process update from the authoritative server
				buffer_manager_c.append_to_buffer_dict(packet)


# receive connection response packet from the server and parse it
# save the server's authoritative initial orientation for the player
# update the client wrapper's state to waiting for lobby
func _handle_connection_response(packet: Variant) -> void:
	match typeof(packet):
		TYPE_DICTIONARY:
			if not packet.has("init"):
				print("received invalid packet: ")
				print(packet)
				return
			
			print("Connected: %s" % packet)
			connected = true
			pending = false
			
			# unpack the response packet
			player_id = packet["init"]["player_id"]
			var init_position : Vector3 = packet["init"]["position"]
			var init_rotation: Vector3 = packet["init"]["rotation"]
			
			SettingsMp.init_player_orientation_3D(init_position, init_rotation)
			
			_update_client_state(Client_Wrapper.CLIENT_STATE_TYPES.WAITING_IN_LOBBY)
			
			SignalBusMp.update_client_label.emit(player_id)


func _update_client_state(state: int):
	SignalBusMp.update_client_state.emit(state)
