extends Node

#@onready var input_manager_c: Node = %Input_Manager_C

var e_client := PacketPeerUDP.new()

var connected := false

var player_input_buffer : Array[Vector2]

func _ready() -> void:
	connect_client_to_server()


func connect_client_to_server() -> void:
	e_client.connect_to_host("127.0.0.1", 12345)


func send_connection_string() -> void:
	%Network_Layer_C.simulate_send_string_over_network(e_client, "hello, world!".to_utf8_buffer())


func send_input(input_vec : Vector2) -> void:
	%Network_Layer_C.simulate_sending_input_over_network(e_client, input_vec)


func _physics_process(delta: float) -> void:
	if !connected:
		send_connection_string()
		#send_string_over_network("hello, world!".to_utf8_buffer())
	if e_client.get_available_packet_count() > 0:
		print("Connected: %s" % e_client.get_packet().get_string_from_utf8())
		connected = true
	if Input.is_action_just_pressed("fire_projectile") and connected:
		var input_vec := Vector2(11.0, 11.0)
		send_input(input_vec)
		
	if player_input_buffer.size() > 0:
		# will be refactored later to include controls for rendering delays
		send_input(player_input_buffer.pop_front())


func get_input(input_vec: Vector2) -> void:
	player_input_buffer.append(input_vec)
