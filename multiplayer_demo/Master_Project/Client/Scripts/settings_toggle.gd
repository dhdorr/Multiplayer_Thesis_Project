extends Control

@onready var h_slider: HSlider = $VBoxContainer/HBoxContainer4/VBoxContainer/HSlider
@onready var line_edit: LineEdit = $VBoxContainer/HBoxContainer4/VBoxContainer/LineEdit

func _ready() -> void:
	h_slider.value = SettingsMp.server_tick_rate
	line_edit.text = str(SettingsMp.server_tick_rate)


func hide_settings(proc_type: int) -> void:
	if proc_type == SettingsMp.MP_PROCESS_TYPE.MP_SERVER:
		for c in $VBoxContainer.get_child_count() - 1:
			$VBoxContainer.get_child(c).visible = false
	elif proc_type == SettingsMp.MP_PROCESS_TYPE.MP_CLIENT:
		$VBoxContainer.get_child($VBoxContainer.get_child_count() - 1).visible = false


func _on_prediction_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_client_prediction = toggled_on
	print("prediction: ", toggled_on)


func _on_reconciliation_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_server_reconciliation = toggled_on
	print("reconciliation: ", toggled_on)


func _on_interpolation_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_client_entity_interpolation = toggled_on
	print("interpolation: ", toggled_on)


func _on_h_slider_value_changed(value: float) -> void:
	line_edit.text = str(value)


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	SettingsMp.server_tick_rate = int(line_edit.text)
	print("Server Tick Rate: ", line_edit.text)


func _on_line_edit_text_submitted(new_text: String) -> void:
	SettingsMp.server_tick_rate = int(new_text)
	h_slider.value = int(new_text)
	line_edit.release_focus()
	print("Server Tick Rate: ", new_text)
