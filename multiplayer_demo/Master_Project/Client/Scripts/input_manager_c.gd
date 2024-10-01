class_name Input_Manager_Client extends Node

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C
@onready var player: Test_Player = %Player
@onready var buffer_manager_c: Buffer_Manager_C = %Buffer_Manager_C

var direction : Vector2
var input_buffer : Array[Vector2]
var packet_arr : Array[Dictionary]
var input_history : Array[Dictionary]
var current_packet := 0

func _physics_process(delta: float) -> void:
	if connection_manager_c.connected:
		direction = Input.get_vector("move_left","move_right","move_up","move_down")
		
		# Client Prediction
		player.velocity = player.velocity.move_toward(direction * 300.0, delta * 1600.0)
		player.move_and_slide()
		
		# Generating serialized packet and sending it out
		var input_dict : Dictionary = {"player_id" : connection_manager_c.player_id, "input_vec" : player.velocity, "packet_id": current_packet}
		connection_manager_c.send_input(input_dict)
		input_history.append(input_dict)
		
		server_reconciliation(delta)
		
		
		current_packet += 1


func server_reconciliation(delta : float) -> void:
	#print("called deferred...")
	if buffer_manager_c.is_buffer_ready and buffer_manager_c.buffer_d.size() > 0:
		var packet : Dictionary = buffer_manager_c.buffer_d.pop_front()
		player.position = packet["position"]
		var last_confirmed_packet_id : int = packet["packet_id"]
		for i in range(last_confirmed_packet_id, input_history.size()):
			player.velocity = input_history[i]["input_vec"]
			#player.velocity = player.velocity.move_toward(input_history[i]["input_vec"] * 300.0, delta * 1600.0)
			player.move_and_slide()
