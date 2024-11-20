class_name Start_Screen_Menu extends Control

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C

#const CHARACTER_CONTROLLER_3D = preload("res://Master_Project/Client/Scenes/character_controller_3d.tscn")
#const WORLD_3D = preload("res://Master_Project/world_3d.tscn")

func _on_connect_button_pressed() -> void:
	var err := connection_manager_c._connect_to_server()
	if err != OK:
		print_debug(err)
		return
	
	# TODO Display a waiting screen #
	# here
	print("waiting for server connection response...")
	# ----------------------------- #
	
	# Remove Menu
	#add_sibling(WORLD_3D.instantiate())
	#add_sibling(CHARACTER_CONTROLLER_3D.instantiate())
	#queue_free()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
