extends MarginContainer
class_name PLAYER_NAMEPLATE

@onready var username_label: Label = $HBoxContainer/username_label
@onready var check_box: CheckBox = $HBoxContainer/CheckBox
@onready var color_rect: ColorRect = $HBoxContainer/ColorRect

var owning_player_id : int

func set_up_nameplate(player_id : int, username : String, is_ready : bool, belongs_to_this_client : bool) -> void:
	username_label.text = username.to_upper()
	check_box.button_pressed = is_ready
	owning_player_id = player_id
	if not belongs_to_this_client:
		check_box.disabled = true
		color_rect.color = Color.DEEP_PINK
	else:
		color_rect.color = Color.CORAL


func set_ready_state(is_ready : bool, belongs_to_this_client : bool) -> void:
	check_box.button_pressed = is_ready
	if not belongs_to_this_client and is_ready:
		color_rect.color = Color.PALE_GREEN
	elif belongs_to_this_client and is_ready:
		color_rect.color = Color.DEEP_SKY_BLUE
	
	


func _on_check_box_toggled(toggled_on: bool) -> void:
	if not check_box.disabled:
		SignalBusMp.client_ready_up.emit(toggled_on)
