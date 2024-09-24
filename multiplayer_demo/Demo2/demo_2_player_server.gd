extends CharacterBody2D
const PROJECTILE_NODE_2D = preload("res://Demo2/projectile_node_2d.tscn")
# server

var player_input_buffer :Array[Vector2] = [Vector2.ZERO]
var delay_counter : float = 0.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	delay_counter += delta

	if delay_counter > Settings.server_input_buffer_time * delta:
		delay_counter = 0.0
		# can simulate many frames of movement in one physics process frame
		# by using a for loop and calling move and slide each iteration.
		# funny enough, this actually causes time warping
		# where when the time scale is lowered, the server responds before the client
		for i in player_input_buffer:
			#var player_input : Vector2 = player_input_buffer.pop_front()
			# testing, remove later
			if i == Settings.magic_fire_projectile_input:
				var temp_projectile := PROJECTILE_NODE_2D.instantiate()
				add_sibling(temp_projectile)
				temp_projectile.position = Vector2(self.position.x, self.position.y - 64)
				continue
			# ^^^^^^
			velocity = velocity.move_toward(i * 300.0, delta * 1600)
			move_and_slide()
		player_input_buffer.clear()
	
	

#func consume_input_buffer(recv_buff: Array[Vector2]) -> void:
	#player_input_buffer.append_array(recv_buff)
	

func add_to_input_buffer(recv_buff: Array[Vector2]) -> void:
	if player_input_buffer.size() + recv_buff.size() > 15:
		for i in recv_buff:
			player_input_buffer.pop_front()
			player_input_buffer.append(i)
	else:
		player_input_buffer.append_array(recv_buff)
