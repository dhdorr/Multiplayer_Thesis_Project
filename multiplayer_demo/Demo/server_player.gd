class_name PlayerServer extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var input_device := ClientInputDevice.InputDevice.new()
var player_inputs := Vector2.ZERO

func _ready() -> void:
	add_child(input_device)
	input_device.send_input_to_server.connect(_process_world)
	

func _physics_process(delta: float) -> void:
	self.velocity = self.velocity.move_toward(player_inputs * SPEED, SPEED * 2 * delta)
	move_and_slide()

func _process_world(req_input: Vector2) -> void:
	player_inputs = req_input
