extends CharacterBody2D


var player_input_buffer :Array[Vector2] = [Vector2.ZERO]
var last_dir := Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# can simulate many frames of movement in one physics process frame
	# by using a for loop and calling move and slide each iteration.
	#for i in player_input_buffer:
		#velocity = velocity.move_toward(i * 300.0, delta * 1600)
		#move_and_slide()
	#player_input_buffer.clear()
	
	# PREDICTION!!!
	# this way, if the server ever responds with a correction,
	# we can just swap out the input buffer with the update
	if player_input_buffer.size() > 0:
		last_dir = player_input_buffer.pop_front()
	self.velocity = self.velocity.move_toward(last_dir * 300.0, delta * 1600.0)
	move_and_slide()

func consume_input_buffer(recv_buff: Array[Vector2]) -> void:
	player_input_buffer.append_array(recv_buff)
