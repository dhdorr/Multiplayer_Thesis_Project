class_name Start_Screen_Menu extends Control

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C
@onready var username_text_box: LineEdit = $VBoxContainer/HBoxContainer3/Username_TextBox
@onready var passcode_text_box: LineEdit = $VBoxContainer/HBoxContainer4/Passcode_TextBox
@onready var server_ip_text_box: LineEdit = $VBoxContainer/HBoxContainer/Server_IP_TextBox


func _on_connect_button_pressed() -> void:
	if not username_text_box.text.is_empty():
		SettingsMp.client_username = username_text_box.text
	if not passcode_text_box.text.is_empty():
		SettingsMp.client_passcode = passcode_text_box.text
	if not server_ip_text_box.text.is_empty():
		SettingsMp.server_ip_address = server_ip_text_box.text
	
	var err := connection_manager_c._connect_to_server()
	if err != OK:
		print_debug(err)
		return
	
	print("waiting for server connection response...")
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()
