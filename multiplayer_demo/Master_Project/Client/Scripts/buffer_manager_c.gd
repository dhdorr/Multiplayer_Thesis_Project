class_name Buffer_Manager_C extends Node

var buffer : Array[Vector2]
var buffer_d : Array[Dictionary]
var is_first_packet := true
var is_buffer_ready := false
@onready var timer : Timer = Timer.new()

# called by the connection manager


# called by the connection manager
func append_to_buffer_dict(recv : Dictionary) -> void:
	buffer_d.append(recv)
	is_buffer_ready = true


# called by the player
func remove_from_buffer() -> Dictionary:
	return buffer_d.pop_front()
