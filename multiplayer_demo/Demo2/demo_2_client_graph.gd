extends Node2D

const CLIENT_INPUT_PACKET_ICON = preload("res://Demo2/client_input_packet_icon.tscn")


@onready var marker_2d: Marker2D = %Marker2D
@onready var network_marker_2d: Marker2D = %NetworkMarker2D

func spawn_packet_icon(buff: Array[Vector2]) -> void:
	var icon_instance = CLIENT_INPUT_PACKET_ICON.instantiate()
	add_child(icon_instance)
	icon_instance.position = marker_2d.position
	var tween := get_tree().create_tween().tween_property(icon_instance, "position:x", 1152.0, 1.0)
	tween.finished.connect(icon_instance.queue_free)
	spawn_networked_packet_icon()

func spawn_networked_packet_icon() -> void:
	var icon_instance = CLIENT_INPUT_PACKET_ICON.instantiate()
	add_child(icon_instance)
	icon_instance.position = network_marker_2d.position
	var tween := get_tree().create_tween()
	tween.tween_property(icon_instance, "position:x", network_marker_2d.position.x + 57.6, Settings.get_network_latency_seconds())
	tween.parallel().tween_property(icon_instance, "position:y", network_marker_2d.position.y + 100.0, Settings.get_network_latency_seconds())
	tween.finished.connect(icon_instance.queue_free)

# Make a destroy func that plays a short tween of the packet fading out and shrinking
# then calls queue_free on it
