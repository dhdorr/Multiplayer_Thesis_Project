extends Node2D

@onready var server_marker: Marker2D = %Server_Marker
@onready var client_io := ClientInputDevice.InputDevice.new()
const SERVER_PACKET_ICON = preload("res://Demo/server_packet_icon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(client_io)
	#client_io.send_input_to_server.connect(_recv_input)


func _recv_input(recv_input: Vector2):
	var temp_icon := SERVER_PACKET_ICON.instantiate()
	server_marker.add_child(temp_icon)
	temp_icon.anim("travel")
		
