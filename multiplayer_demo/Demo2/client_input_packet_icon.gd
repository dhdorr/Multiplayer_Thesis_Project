extends Sprite2D

@onready var frame_line_marker_2d: Marker2D = %Frame_Line_Marker2D


func _ready() -> void:
	var length_of_line : float = 1152.0 - 64.0 - 64.0
	var line_pos_x := 64.0 + (length_of_line * Settings.input_delay * 16.667) / 1000.0
	frame_line_marker_2d.position.x =  line_pos_x
