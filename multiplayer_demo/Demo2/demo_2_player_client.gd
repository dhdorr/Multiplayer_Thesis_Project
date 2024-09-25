extends CharacterBody2D

const PROJECTILE_NODE_2D = preload("res://Demo2/projectile_node_2d.tscn")
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
	# client may always be a frame behind due to buffering
	# PREDICTION!!!
	# this way, if the server ever responds with a correction,
	# we can just swap out the input buffer with the update
	if player_input_buffer.size() > 0:
		var player_input : Vector2 = player_input_buffer.pop_front()
		# testing, remove later
		if player_input == Settings.magic_fire_projectile_input:
			var temp_projectile := PROJECTILE_NODE_2D.instantiate()
			add_sibling(temp_projectile)
			temp_projectile.position = Vector2(self.position.x, self.position.y - 64)
			#print("Displaying projectile on client")
			#print("Client input buffer size: ", player_input_buffer.size())
			#print("Client input buffer elements: ", player_input_buffer)
			
			if player_input_buffer.size() > 0:
				last_dir = player_input_buffer.pop_front()
		else:
			last_dir = player_input
			#print("Client input buffer size: ", player_input_buffer.size())
		# ^^^^^^
		#last_dir = player_input_buffer.pop_front()
	self.velocity = self.velocity.move_toward(last_dir * 300.0, delta * 1600.0)
	move_and_slide()

func consume_input_buffer(recv_buff: Array[Vector2]) -> void:
	#print("recv buff size: ", recv_buff.size())
	#print("pre append Client input buffer size: ", player_input_buffer.size())
	#for i in recv_buff:
		#player_input_buffer.append(i)
	player_input_buffer.append_array(recv_buff)

func clear_input_buffer() -> void:
	player_input_buffer.clear()
