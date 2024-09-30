class_name Input_Manager_Client extends Node

var direction : Vector2
var input_buffer : Array[Vector2]
var packet_arr : Array[Dictionary]
var current_packet := 1

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	input_buffer.append(direction)
	

func append_to_packet_arr(recv : Dictionary) -> void:
	packet_arr.append(recv)

func remove_from_packet_arr(key : int) -> void:
	# key - 1 cuz i made the packet count 1 based for some reason
	packet_arr.remove_at(key-1)
