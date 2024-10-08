class_name Buffer_Manager_C extends Node

@onready var ghost_manager_c: Ghost_Manager_C = %Ghost_Manager_C
@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C
@onready var input_manager_c: Input_Manager_Client = %Input_Manager_C

#var buffer : Array[Vector2]
var buffer_d : Array[Dictionary]
var waiting_for_first_packet := true
var is_buffer_ready := false
# latency in terms of frames (16.667 ms)
var latency_variance : int = 3
var last_consumed_packet : Dictionary
var counter : int = 0

var consumable_queue : Array[Dictionary]
var consumable_counter : int = 0

func _physics_process(delta: float) -> void:
	if !waiting_for_first_packet:
		# The purpose of the buffer manager is to hold onto packets for some
		# period of time, to compensate for the variance in latency of
		# packets traveling from the server to the client.
		#
		# We still want to execute packets one at a time, but we also need
		# to ensure packets are being consumed at a consistent rate. So, we use
		# the buffer to stall for time while inputs may be coming in, then
		#  consume at the same tick rate as the server.
		if counter >= SettingsMp.get_server_tick_rate() + latency_variance and buffer_d.size() > 0:
			remove_from_buffer()
			counter = 0
		else:
			counter += 1
		
		if consumable_counter >= SettingsMp.get_server_tick_rate() and consumable_queue.size() > 0:
			consume_from_queue()
			consumable_counter = 0
		else:
			consumable_counter += 1
		

func start_buffer_on_receipt(recv: Dictionary) -> void:
	print("testing: ", get_physics_process_delta_time())
	buffer_d.append(recv)
	is_buffer_ready = true
	waiting_for_first_packet = false

# called by the connection manager
func append_to_buffer_dict(recv : Dictionary) -> void:
	buffer_d.append(recv)
	#is_buffer_ready = true


func remove_from_buffer() -> void:
	consumable_queue.append_array(buffer_d)
	buffer_d.clear()
	


func consume_from_queue() -> void:
	var item : Dictionary = consumable_queue.pop_front()
	
	if item.has(connection_manager_c.player_id):
		input_manager_c.update_player_authoritative_position(item)
	
	ghost_manager_c.spawn_peer_characters_2(item)
