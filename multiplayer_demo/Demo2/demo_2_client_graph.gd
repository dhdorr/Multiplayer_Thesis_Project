extends Node2D

const CLIENT_INPUT_PACKET_ICON = preload("res://Demo2/client_input_packet_icon.tscn")

@export_range(0.0, 1.0, 0.1) var graph_time_scale := 1.0

@onready var marker_2d: Marker2D = %Marker2D
@onready var network_layer: Node = %Network_Layer
@onready var input_manager: Node = %Input_Manager


func _ready() -> void:
	pass
	


func spawn_packet_icon(buff: Array[Vector2]):
	var icon_instance = CLIENT_INPUT_PACKET_ICON.instantiate()
	add_child(icon_instance)
	icon_instance.position = marker_2d.position
	var tween := get_tree().create_tween().tween_property(icon_instance, "position:x", 1152.0, 1.0)
	tween.finished.connect(icon_instance.queue_free)
