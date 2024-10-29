class_name Client_Wrapper extends Node

var player_init : Dictionary

func _ready() -> void:
	SignalBusMp.update_client_label.connect(update_label)
	SignalBusMp.setup_settings_toggle.connect(setup_settings_menu)

func update_label(p_id: int) -> void:
	$Label.text = "Client - " + str(p_id)

func setup_settings_menu(proc_type: int) -> void:
	$Settings_Toggles.hide_settings(proc_type)
