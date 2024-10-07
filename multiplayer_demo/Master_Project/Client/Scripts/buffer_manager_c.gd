class_name Buffer_Manager_C extends Node


#var buffer : Array[Vector2]
var buffer_d : Array[Dictionary]
var waiting_for_first_packet := true
var is_buffer_ready := false

var last_consumed_packet : Dictionary
var counter : int = 0

func _physics_process(delta: float) -> void:
	if !waiting_for_first_packet:
		if counter >= 3:
			#print("remove from buffer")
			remove_from_buffer()
			counter = 0
		else:
			counter += 1

func start_buffer_on_receipt(recv: Dictionary) -> void:
	print("testing: ", get_physics_process_delta_time())
	buffer_d.append(recv)
	is_buffer_ready = true
	waiting_for_first_packet = false
	#get_tree().create_timer(1.0/60.0).timeout.connect(test_buff_stuff)

# called by the connection manager
func append_to_buffer_dict(recv : Dictionary) -> void:
	buffer_d.append(recv)
	#is_buffer_ready = true


# called by the player
func remove_from_buffer() -> void:
	if buffer_d.size() > 0:
		var temp : Dictionary = buffer_d.pop_front()
		last_consumed_packet = temp
		SignalBusMp.dispense_from_buffer_manager.emit(temp)
	else:
		SignalBusMp.dispense_from_buffer_manager.emit(last_consumed_packet)


func test_buff_stuff() -> void:
	is_buffer_ready = true
	#buffer_d.append(packet)
