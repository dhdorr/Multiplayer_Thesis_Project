extends CharacterBody2D

#@onready var input_manager_c: Node = %Input_Manager_C

var SPEED : float = 300.0
var ACCELERATION : float = 1500.0

var player_input_buffer : Array[Vector2]

func _physics_process(delta: float) -> void:
	if player_input_buffer.size() > 0:
		# will be refactored later to include controls for rendering delays
		
		var desired_velocity : Vector2 = player_input_buffer.pop_front() * SPEED
		self.velocity = self.velocity.move_toward(desired_velocity, delta * ACCELERATION)
		move_and_slide()

func get_input(input_vec: Vector2) -> void:
	player_input_buffer.append(input_vec)
