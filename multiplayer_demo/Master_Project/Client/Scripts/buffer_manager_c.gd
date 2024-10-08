class_name Buffer_Manager_C extends Node

@onready var ghost_manager_c: Ghost_Manager_C = %Ghost_Manager_C
@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C
@onready var input_manager_c: Input_Manager_Client = %Input_Manager_C

#var buffer : Array[Vector2]
var buffer_d : Array[Dictionary]
var waiting_for_first_packet := true
var is_buffer_ready := false

var last_consumed_packet : Dictionary
var counter : int = 0

func _physics_process(delta: float) -> void:
	if !waiting_for_first_packet:
		
		if counter >= SettingsMp.get_server_tick_rate():
			#print(buffer_d, "\n")
			remove_from_buffer()
			#buffer_d.clear()
			counter = 0
		else:
			counter += 1
		

func start_buffer_on_receipt(recv: Dictionary) -> void:
	print("testing: ", get_physics_process_delta_time())
	buffer_d.append(recv)
	is_buffer_ready = true
	waiting_for_first_packet = false

# called by the connection manager
func append_to_buffer_dict(recv : Dictionary) -> void:
	buffer_d.append(recv)
	#is_buffer_ready = true


# called by the player
func remove_from_buffer() -> void:
	if buffer_d.size() > 0:
		var item : Dictionary = buffer_d.pop_front()
		
		if item.has(connection_manager_c.player_id):
			input_manager_c.update_player_authoritative_position(item)
		
		ghost_manager_c.spawn_peer_characters_2(item)
