extends Control


func _on_prediction_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_client_prediction = toggled_on
	print("prediction: ", toggled_on)


func _on_reconciliation_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_server_reconciliation = toggled_on
	print("reconciliation: ", toggled_on)
