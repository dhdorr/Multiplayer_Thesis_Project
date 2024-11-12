class_name Connection_Manager_Client extends Node

@onready var buffer_manager_c: Buffer_Manager_C = %Buffer_Manager_C
#@onready var input_manager_c: Input_Manager_Client

var e_client := PacketPeerUDP.new()

var connected := false
var test_connected := false
var pending := false

var player_id : int = 0

#func _process(delta):
	##if Input.is_action_just_pressed("fire_projectile") and !test_connected:
		##_connect_to_server()
	#if !connected and e_client.get_available_packet_count() > 0:
		#print("Connected: %s" % e_client.get_packet().get_string_from_utf8())
		#test_connected = true
		#connected = true
		#pending = false
		
func _ready() -> void:
	var my_id : int = randi_range(0,10)
	e_client.bind(5000+my_id, "127.0.0.1")
	e_client.connect_to_host("127.0.0.1", 12345)
	
	
func _connect_to_server() -> Error:
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


func _physics_process(delta: float) -> void:
	if e_client.get_available_packet_count() > 0:
		var packet = e_client.get_var()
		if !connected:
			_handle_connection_response(packet)
		else:
			_handle_world_state_response(packet)
		

func _handle_world_state_response(packet: Variant) -> void:
	match typeof(packet):
		TYPE_DICTIONARY:
			if buffer_manager_c.waiting_for_first_packet:
				buffer_manager_c.start_buffer_on_receipt(packet)
			else:
				# Process update from the authoritative server
				buffer_manager_c.append_to_buffer_dict(packet)


func _handle_connection_response(packet: Variant) -> void:
	match typeof(packet):
		TYPE_DICTIONARY:
			print("Connected: %s" % packet)
			connected = true
			pending = false
			player_id = packet["init"]["player_id"]
			var init_pos : Vector3 = packet["init"]["position"]
			#var siblings := get_tree().get_nodes_in_group("input_mgr")
			#input_manager_c = siblings[0]
			#input_manager_c.init_player_position(packet["init"])
			SettingsMp.init_player_position_3D(init_pos)
			SignalBusMp.initialize_player_position_on_player.emit()
			SignalBusMp.update_client_label.emit(player_id)
