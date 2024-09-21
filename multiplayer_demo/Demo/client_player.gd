class_name PlayerClient extends CharacterBody2D


const SPEED = 300.0


@onready var input_device := ClientInputDevice.InputDevice.new()
@onready var serialized_player := {"pos": self.position, "vel": Vector2.ZERO}

func _ready() -> void:
	add_child(input_device)
	input_device.server_response_to_client.connect(_test_process_server_response)
	

func _physics_process(delta: float) -> void:
	var client_input := input_device.client_input
	self.velocity = self.velocity.move_toward(client_input * SPEED, SPEED * 2 * delta)
	
	move_and_slide()
	

func _test_process_server_response(resp_player: Dictionary) -> void:
	pass
	#print(resp_player)
	#print(serialized_player)
	
