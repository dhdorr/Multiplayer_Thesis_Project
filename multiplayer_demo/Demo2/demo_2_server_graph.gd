extends Node2D

@onready var network_marker_2d: Marker2D = %NetworkMarker2D
@onready var marker_2d: Marker2D = %Marker2D
@onready var server_line_2d: Line2D = %Server_Line2D
@onready var half_rtt_marker_2d: Marker2D = %Half_RTT_Marker2D
@onready var rtt_control: Control = $Half_RTT_Marker2D/Control
@onready var buffer_control: Control = $NetworkMarker2D/Control


func _process(delta: float) -> void:
	#var temp_x : float = server_line_2d.get_point_position(1).x - server_line_2d.get_point_position(0).x
	#var travel_x := Settings.time_line_length * (Settings.get_network_latency_seconds() + Settings.get_server_buffer_time_seconds())
	#network_marker_2d.position.x = marker_2d.position.x + travel_x
	#network_marker_2d.position = network_marker_2d.position.move_toward(Vector2(marker_2d.position.x + travel_x, 0.0), delta * 10000.0)
	
	# Extends but never moves
	rtt_control.size.x = Settings.get_network_latency_seconds() * 60.0 * 64.0
	
	# Moves and extends
	network_marker_2d.position.x = rtt_control.size.x + half_rtt_marker_2d.position.x
	#network_marker_2d.position.y = 100.0
	buffer_control.size.x = Settings.get_server_buffer_time_seconds() * 64.0 * 60.0
