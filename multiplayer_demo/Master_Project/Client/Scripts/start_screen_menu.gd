class_name Start_Screen_Menu extends Control

@onready var connection_manager_c: Connection_Manager_Client
@onready var username_text_box: LineEdit = $VBoxContainer/HBoxContainer3/Username_TextBox
@onready var passcode_text_box: LineEdit = $VBoxContainer/HBoxContainer4/Passcode_TextBox
#@onready var server_ip_text_box: LineEdit = $VBoxContainer/HBoxContainer/Server_IP_TextBox
@onready var server_ip_text_box: LineEdit = $VBoxContainer/MarginContainer2/HBoxContainer/Server_IP_TextBox

const SKIN_SELECTION_UI = preload("res://Master_Project/Client/Scenes/skin_selection_ui.tscn")
@onready var headshot_3d: Node3D = %Headshot3D
const SKINS_PATH = "res://Master_Project/assets/Characters/Scenes/"
@onready var skin_text_box: LineEdit = $VBoxContainer/HBoxContainer5/Skin_TextBox


func _ready() -> void:
	connection_manager_c = get_tree().get_first_node_in_group("conn_mgr")
	username_text_box.text = SettingsMp.client_username
	var skin := load(SKINS_PATH + SettingsMp.selected_skin_name + "_1.tscn")
	var skin_instance : Node3D = skin.instantiate()
	headshot_3d.add_child(skin_instance)
	skin_text_box.text = SettingsMp.selected_skin_name


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


func _on_skin_button_pressed() -> void:
	SignalBusMp.open_skin_selection.emit()
	queue_free()
	#get_tree().change_scene_to_packed(SKIN_SELECTION_UI)


func _on_username_text_box_text_changed(new_text: String) -> void:
	SettingsMp.client_username = new_text
