extends Node2D

@onready var graph_client: Control = %Control
@onready var request_icon: TextureRect = $Control/VBoxContainer/TextureRect

var input_buffer_count := 0
var can_input := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_right") and can_input:
		print("3 frame delay")
		_start_input_buffer_timer()
		#request_icon.position.x += 20.0

func _start_input_buffer_timer() -> void:
	#can_input = false
	get_tree().create_timer(0.1).timeout.connect(
		func() -> void: 
			print("Server Approves")
			can_input = true
			request_icon.position.x += 20.0
	)
	
