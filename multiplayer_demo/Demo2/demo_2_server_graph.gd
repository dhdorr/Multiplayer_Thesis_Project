extends Node2D

@onready var network_marker_2d: Marker2D = %NetworkMarker2D
@onready var marker_2d: Marker2D = %Marker2D
@onready var server_line_2d: Line2D = %Server_Line2D

const CLIENT_INPUT_PACKET_ICON = preload("res://Demo2/client_input_packet_icon.tscn")


func _ready() -> void:
	var temp_timer : Timer = Timer.new()
	add_child(temp_timer)
	temp_timer.start(0.5)
	temp_timer.timeout.connect(spawn_server_packet)
	

func _process(delta: float) -> void:
	var temp_x : float = server_line_2d.get_point_position(1).x - server_line_2d.get_point_position(0).x
	network_marker_2d.position.x = marker_2d.position.x + (Settings.get_network_latency_seconds() * temp_x)
	

func spawn_server_packet() -> void:
	var server_packet := CLIENT_INPUT_PACKET_ICON.instantiate()
	add_child(server_packet)
	server_packet.position = marker_2d.position
	var tween := get_tree().create_tween().tween_property(server_packet, "position:x", 1152.0, 1.0)
	tween.finished.connect(server_packet.queue_free)
