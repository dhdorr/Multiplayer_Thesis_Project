class_name Buffer_Manager_C extends Node

var buffer : Array[Vector2]
var is_first_packet := true
var is_buffer_ready := false
@onready var timer : Timer = Timer.new()

# called by the connection manager
func append_to_buffer(recv : Vector2) -> void:
	buffer.append(recv)
	if is_first_packet:
		add_child(timer)
		timer.one_shot = true
		timer.start(1.0/60.0)
		timer.timeout.connect(func() -> void: is_buffer_ready = true)
		is_first_packet = false

# called by the player
func remove_from_buffer() -> Vector2:
	return buffer.pop_front()
