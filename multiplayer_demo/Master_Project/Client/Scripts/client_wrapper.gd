class_name Client_Wrapper extends Node

var player_init : Dictionary

func _ready() -> void:
	SignalBusMp.update_client_label.connect(update_label)

func update_label(p_id: int) -> void:
	$Label.text = "Client - " + str(p_id)
