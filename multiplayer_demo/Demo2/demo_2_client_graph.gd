extends Node2D


const NETWORK_PACKET_ICON = preload("res://Demo2/network_packet_icon.tscn")
const CLIENT_INPUT_PACKET_ICON = preload("res://Demo2/client_input_packet_icon.tscn")

@onready var marker_2d: Marker2D = %Marker2D
@onready var network_marker_2d: Marker2D = %NetworkMarker2D
var frame_counter := 0

func spawn_packet_icon(buff: Array[Vector2]) -> void:
	var icon_instance = CLIENT_INPUT_PACKET_ICON.instantiate()
	add_child(icon_instance)
	icon_instance.position = marker_2d.position
	
	# experimenting with width of frame * frames per second
	icon_instance.set_up_packet(64.0 * 60.0, frame_counter)
	frame_counter += 1
	
	spawn_networked_packet_icon()
	

func spawn_networked_packet_icon() -> void:
	var icon_instance = NETWORK_PACKET_ICON.instantiate()
	add_child(icon_instance)
	icon_instance.position = network_marker_2d.position
	icon_instance.set_up_network_packet(64.0 * 60.0)


# Make a destroy func that plays a short tween of the packet fading out and shrinking
# then calls queue_free on it
