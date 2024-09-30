class_name Connection_Manager_Client extends Node


@onready var input_manager := Input_Manager_Client.new()

var e_client := PacketPeerUDP.new()

var connected := false


func _ready() -> void:
	connect_client_to_server()
	# Enable input manager
	add_child(input_manager)


func connect_client_to_server() -> void:
	e_client.connect_to_host("127.0.0.1", 12345)


func send_connection_string() -> void:
	%Network_Layer_C.simulate_send_string_over_network(e_client, "hello, world!".to_utf8_buffer())


func send_input(input_vec : Vector2) -> void:
	%Network_Layer_C.simulate_sending_input_over_network(e_client, input_vec)


func _physics_process(delta: float) -> void:
	if !connected:
		send_connection_string()
	# Received packet from server
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		match typeof(packet):
			TYPE_VECTOR2:
				if connected:
					#print("Update position from server: %s" % str(packet))
					input_manager.Buffer_On_Receipt.buffer.append(packet)
			TYPE_PACKED_BYTE_ARRAY:
				if !connected:
					print("Connected: %s" % packet.get_string_from_utf8())
					connected = true
	# Testing shooting projectile packet
	if Input.is_action_just_pressed("fire_projectile") and connected:
		var input_vec := Vector2(11.0, 11.0)
		send_input(input_vec)
		
	if input_manager.input_buffer.size() > 0:
		# will be refactored later to include controls for rendering delays
		send_input(input_manager.input_buffer.pop_front())
