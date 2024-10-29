extends Node


func _ready() -> void:
	SignalBusMp.setup_settings_toggle.connect(setup_settings_menu)


func setup_settings_menu(proc_type: int) -> void:
	$Settings_Toggles.hide_settings(proc_type)
