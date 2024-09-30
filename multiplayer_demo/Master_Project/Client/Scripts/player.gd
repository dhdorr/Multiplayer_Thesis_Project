class_name Test_Player extends CharacterBody2D

@onready var input_manager := Input_Manager_Client.new()
@onready var buffer_manager_c: Buffer_Manager_C = %Buffer_Manager_C

var SPEED : float = 300.0
var ACCELERATION : float = 1500.0


func _ready() -> void:
	# Enable manager modules via composition
	add_child(input_manager)

func _physics_process(delta: float) -> void:
	# Consume position updates from the server
	# will need to be refactored to support server reconciliation, later
	if buffer_manager_c.buffer.size() > 0 and buffer_manager_c.is_buffer_ready:
		self.position = buffer_manager_c.remove_from_buffer()
	elif !buffer_manager_c.is_buffer_ready:
		print("buffer is not ready yet")
		
	if input_manager.input_buffer.size() > 0:
		# will be refactored later to include controls for rendering delays
		var desired_velocity : Vector2 = input_manager.input_buffer.pop_front() * SPEED
		self.velocity = self.velocity.move_toward(desired_velocity, delta * ACCELERATION)
		move_and_slide()
