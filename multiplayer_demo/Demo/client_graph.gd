extends Node2D

@onready var client_io := ClientInputDevice.InputDevice.new()
@onready var client_marker: Marker2D = %Client_Marker

const INPUT_ICON = preload("res://Demo/input_icon.tscn")

var can_recv_input := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(client_io)
	client_io.send_input_to_client.connect(_recv_input)
	#client_io.send_input_to_server.connect(_recv_input)


func _physics_process(delta: float) -> void:
	pass

func _recv_input(recv_input: Vector2):
	#if can_recv_input and client_io.client_input != Vector2.ZERO:
		##print("ok i did it")
		#can_recv_input = false
		#get_tree().create_timer(1.0).timeout.connect(func() -> void: can_recv_input = true)
		#var temp_icon := INPUT_ICON.instantiate()
		#client_marker.add_child(temp_icon)
		#temp_icon.anim("travel")
		
	var temp_icon := INPUT_ICON.instantiate()
	client_marker.add_child(temp_icon)
	temp_icon.anim("travel")
		
