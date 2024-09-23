extends Node2D

@onready var network_marker_2d: Marker2D = %NetworkMarker2D
@onready var marker_2d: Marker2D = %Marker2D
@onready var server_line_2d: Line2D = %Server_Line2D

const CLIENT_INPUT_PACKET_ICON = preload("res://Demo2/client_input_packet_icon.tscn")


func _process(delta: float) -> void:
	#var temp_x : float = server_line_2d.get_point_position(1).x - server_line_2d.get_point_position(0).x
	var num := 64.0 * 60.0
	var travel_x := num * (Settings.get_network_latency_seconds() + Settings.get_input_delay_secods())
	network_marker_2d.position.x = marker_2d.position.x + travel_x
	#network_marker_2d.position = network_marker_2d.position.move_toward(Vector2(marker_2d.position.x + travel_x, 0.0), delta * 10000.0)
	
