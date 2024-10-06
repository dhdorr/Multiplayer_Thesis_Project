class_name Connection_Manager_Client extends Node


@onready var buffer_manager_c: Buffer_Manager_C = %Buffer_Manager_C
@onready var input_manager_c: Input_Manager_Client = %Input_Manager_C

var e_client := PacketPeerUDP.new()

var connected := false

var packet_id := 0

var player_id : int = 0

func _ready() -> void:
	connect_client_to_server()
	# Enable component modules
	#add_child(input_manager)


func connect_client_to_server() -> void:
	e_client.connect_to_host("127.0.0.1", 12345)


func send_connection_string() -> void:
	%Network_Layer_C.simulate_send_string_over_network(e_client, "hello, world!".to_utf8_buffer())


func send_input(input_dict : Dictionary) -> void:
	%Network_Layer_C.simulate_sending_input_over_network(e_client, input_dict)


func _physics_process(delta: float) -> void:
	if !connected:
		send_connection_string()
	# Received packet from server
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		match typeof(packet):
			TYPE_DICTIONARY:
				if connected:
					# Process update from the authoritative server
					buffer_manager_c.append_to_buffer_dict(packet)
				if !connected:
					print("Connected: %s" % packet)
					connected = true
					player_id = packet["player_id"]
					input_manager_c.init_player_position(packet)
					
