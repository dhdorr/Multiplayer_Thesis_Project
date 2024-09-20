extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var input_device := ClientInputDevice.InputDevice.new()

func _ready() -> void:
	add_child(input_device)
	

func _physics_process(delta: float) -> void:
	var client_input := input_device.client_input
	self.velocity = self.velocity.move_toward(client_input * SPEED, SPEED * 2 * delta)
	move_and_slide()
