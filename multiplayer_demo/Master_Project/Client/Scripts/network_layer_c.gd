extends Node

var network_latency_ms = 50.0

var e_client := PacketPeerUDP.new()

var connected := false

func _ready() -> void:
	connect_client_to_server()
	#get_tree().create_timer(network_latency_ms / 1000.0).timeout.connect(connect_client_to_server)
	

func connect_client_to_server() -> void:
	#e_client.connect_to_host("127.0.0.1", 12345)
	#e_client.bind(12345, "127.0.0.1")
	e_client.set_dest_address("127.0.0.1", 12345)
	#e_client.put_packet("hello, world!".to_utf8_buffer())
	#connected = true
	

func _physics_process(delta: float) -> void:
	if !connected:
		e_client.put_packet("hello, world!".to_utf8_buffer())
	if e_client.get_available_packet_count() > 0:
		print("Connected: %s" % e_client.get_packet().get_string_from_utf8())
		connected = true
	if Input.is_action_just_pressed("fire_projectile") and connected:
		#connect_client_to_server()
		e_client.put_packet("bang bang bang!".to_utf8_buffer())
		#print(e_client.is_socket_connected())
		#print("sending packet")
