extends MarginContainer
class_name PLAYER_NAMEPLATE


@onready var username_label: Label = %username_label
@onready var background_color_rect: ColorRect = $Background_ColorRect
@onready var ready_check_box: CheckBox = %Ready_CheckBox
@onready var ready_color_rect: ColorRect = $MarginContainer/HBoxContainer/Ready_ColorRect

var owning_player_id : int

func set_up_nameplate(player_id : int, username : String, is_ready : bool, belongs_to_this_client : bool) -> void:
	username_label.text = username.to_upper()
	
	owning_player_id = player_id
	background_color_rect.color = Color.SLATE_GRAY
	background_color_rect.modulate.a = 255
	if not belongs_to_this_client:
		ready_check_box.disabled = true
		background_color_rect.modulate.a = 0
	ready_check_box.button_pressed = is_ready
	
	set_ready_state(is_ready, belongs_to_this_client)
		#color_rect.color = Color.DARK_SLATE_GRAY
	#else:
		#color_rect.color = Color.CORAL


func set_ready_state(is_ready : bool, belongs_to_this_client : bool) -> void:
	ready_check_box.button_pressed = is_ready
	if not belongs_to_this_client and is_ready:
		ready_color_rect.color = Color.PALE_GREEN
	elif not belongs_to_this_client and not is_ready:
		ready_color_rect.color = Color(0.209, 0.209, 0.209)
	elif belongs_to_this_client and is_ready:
		ready_color_rect.color = Color.PALE_GREEN
	elif belongs_to_this_client and not is_ready:
		ready_color_rect.color = Color.BLACK


func _on_check_box_toggled(toggled_on: bool) -> void:
	if not ready_check_box.disabled:
		$MarginContainer/AudioStreamPlayer.play()
		SignalBusMp.client_ready_up.emit(toggled_on)
