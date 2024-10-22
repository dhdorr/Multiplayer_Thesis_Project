class_name Start_Screen_Menu extends Control

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C

const CHARACTER_CONTROLLER = preload("res://Master_Project/Client/Scenes/character_controller.tscn")
const WORLD_2D = preload("res://Master_Project/world_2d.tscn")

func _on_connect_button_pressed() -> void:
	var conn_error := connection_manager_c._connect_to_server()
	if conn_error != OK:
		print_debug(conn_error)
		return
	
	# Remove Menu
	add_sibling(WORLD_2D.instantiate())
	add_sibling(CHARACTER_CONTROLLER.instantiate())
	queue_free()
