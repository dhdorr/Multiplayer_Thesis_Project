class_name Test_Player extends CharacterBody2D

@onready var input_manager := Input_Manager_Client.new()
@onready var buffer_manager_c: Buffer_Manager_C = %Buffer_Manager_C

var SPEED : float = 300.0
var ACCELERATION : float = 1200.0
var packet_id := 0

func _ready() -> void:
	# Enable manager modules via composition
	add_child(input_manager)

func _physics_process(delta: float) -> void:
	# Consume position updates from the server
	# will need to be refactored to support server reconciliation, later
	var update_packet : Dictionary
	if buffer_manager_c.buffer_d.size() > 0 and buffer_manager_c.is_buffer_ready:
		update_packet = buffer_manager_c.remove_from_buffer_2()
		self.position = update_packet["position"]
		
		var start : int = update_packet["packet_id"]
		var end : int = input_manager.packet_arr.size()
		for i in range(start, end):
			var desired_velocity : Vector2 = input_manager.packet_arr[i]["input_vec"] * SPEED
			#self.velocity = (desired_velocity * delta) * (delta * ACCELERATION)
			self.velocity = self.velocity.move_toward(desired_velocity, delta)
			#self.velocity = desired_velocity
			move_and_slide()
	elif !buffer_manager_c.is_buffer_ready:
		print("buffer is not ready yet")
	
		
	if input_manager.input_buffer.size() > 0:
		packet_id += 1
		var input_vec : Vector2 = input_manager.input_buffer.pop_front()
		var input_dict : Dictionary = {"player_id" : 1, "input_vec" : input_vec, "packet_id": packet_id}
		input_manager.append_to_packet_arr(input_dict)
		# will be refactored later to include controls for rendering delays
		#var desired_velocity : Vector2 = input_vec * SPEED
		#self.velocity = self.velocity.move_toward(desired_velocity, delta)
		#self.velocity = self.velocity.move_toward(desired_velocity, delta * ACCELERATION)
		#move_and_slide()
