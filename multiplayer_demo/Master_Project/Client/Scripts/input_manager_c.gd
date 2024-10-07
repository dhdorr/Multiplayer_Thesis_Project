class_name Input_Manager_Client extends Node

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C
@onready var player: Test_Player = %Player
@onready var buffer_manager_c: Buffer_Manager_C = %Buffer_Manager_C
@onready var ghost_manager_c: Ghost_Manager_C = %Ghost_Manager_C

var direction : Vector2
var input_buffer : Array[Vector2]
var packet_arr : Array[Dictionary]
var input_history : Array[Dictionary]
var current_packet := 0

var temp_packet : Dictionary

func _ready() -> void:
	# emitted from buffer_manager_c
	SignalBusMp.dispense_from_buffer_manager.connect(init_temp_packet)


func init_temp_packet(packet : Dictionary) -> void:
	temp_packet = packet

func _physics_process(delta: float) -> void:
	if connection_manager_c.connected:
		direction = Input.get_vector("move_left","move_right","move_up","move_down")
		
		# Predict player movement immediately as input comes in
		# this movement will be overwritten by the server's response
		# during the reconciliation step
		if SettingsMp.enable_client_prediction:
			client_prediction(delta, direction)
		
		# Generating serialized input packet and sending it out
		generate_input_packet()
		
		# When the server sends the client a new state (position and velocity)
		# the client must apply that new state, which rewinds the player back
		# a few frames. SO we have to re-simulate the inputs from that past
		# state until now
		if !temp_packet.is_empty():
			var packet : Dictionary = temp_packet
			
			# Spawn in ghost for each peer
			ghost_manager_c.spawn_peer_characters(packet)
			
			if packet.has(connection_manager_c.player_id):
				player.position = packet[connection_manager_c.player_id]["position"]
				player.velocity = packet[connection_manager_c.player_id]["velocity"]
				
				if SettingsMp.enable_server_reconciliation:
					server_reconciliation(delta, packet)
		
		current_packet += 1


func client_prediction(delta: float, dir: Vector2) -> void:
		player.velocity = calculate_movement(dir, player.velocity, delta)
		player.move_and_slide()


func generate_input_packet() -> void:
	var input_dict : Dictionary = {"player_id" : connection_manager_c.player_id, "input_vec" : direction, "packet_id": current_packet}
	connection_manager_c.send_input(input_dict)
	input_history.append(input_dict)


func server_reconciliation(delta : float, packet: Dictionary) -> void:
	#print("called deferred...")
	var last_confirmed_packet_id : int = packet[connection_manager_c.player_id]["packet_id"]
	var range : int = input_history.size() - last_confirmed_packet_id
	for i in range(last_confirmed_packet_id + 1, input_history.size()):
		player.velocity = calculate_movement(input_history[i]["input_vec"], player.velocity, delta)
		player.move_and_slide()


func calculate_movement(dir : Vector2, vel: Vector2, delta : float) -> Vector2:
	var desired_velocity = dir * 300.0
	return player.velocity.move_toward(desired_velocity, delta * 1600.0)
	#return desired_velocity


func _on_prediction_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_client_prediction = toggled_on


func _on_reconciliation_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_server_reconciliation = toggled_on

func init_player_position(packet: Dictionary) -> void:
	player.position = packet["position"]
