extends CharacterBody2D

@onready var input_manager := Input_Manager_Client.new()
@onready var buffer_consumer := Buffer_On_Receipt.Buffer_Consumer.new()

var SPEED : float = 300.0
var ACCELERATION : float = 1500.0


func _ready() -> void:
	# Enable manager modules via composition
	add_child(input_manager)
	add_child(buffer_consumer)

func _physics_process(delta: float) -> void:
	# Consume position updates from the server
	# will need to be refactored to support server reconciliation, later
	if buffer_consumer.buffer.size() > 0:
		#print(buffer_consumer.buffer)
		self.position = buffer_consumer.buffer.pop_front()
		
	if input_manager.input_buffer.size() > 0:
		# will be refactored later to include controls for rendering delays
		var desired_velocity : Vector2 = input_manager.input_buffer.pop_front() * SPEED
		self.velocity = self.velocity.move_toward(desired_velocity, delta * ACCELERATION)
		move_and_slide()
