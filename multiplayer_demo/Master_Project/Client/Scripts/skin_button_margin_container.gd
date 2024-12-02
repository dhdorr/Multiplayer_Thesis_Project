extends MarginContainer
class_name SKIN_BUTTON_CONTAINER

@onready var button: Button = $Button

func set_skin_name_on_button(skin_name : String) -> void:
	button.text = skin_name


func _on_button_pressed() -> void:
	SignalBusMp.swap_skin.emit(button.text)
