extends Control
class_name  SKIN_SELECTION_UI

@onready var marker_3d: Marker3D = $HBoxContainer/VBoxContainer/SubViewportContainer/SubViewport/Node3D/Marker3D
@onready var v_box_container: VBoxContainer = $HBoxContainer/Control/VBoxContainer
const SKINS_PATH = "res://Master_Project/assets/Characters/Scenes/"
const SKIN_BUTTON_MARGIN_CONTAINER = preload("res://Master_Project/Client/Scenes/skin_button_margin_container.tscn")
const START_SCREEN_MENU = preload("res://Master_Project/Client/Scenes/start_screen_menu.tscn")

var current_skin_name : String = ""
var current_skin : Resource
var file_paths : Array

func _ready() -> void:
	var directory := DirAccess.open(SKINS_PATH)
	file_paths = directory.get_files() as Array
	
	file_paths = file_paths.filter(func(file_name : String):
		return file_name.ends_with("_1.tscn")
		)
	
	for skin_name : String in file_paths:
		var new_button := SKIN_BUTTON_MARGIN_CONTAINER.instantiate()
		var truncated_name : String = skin_name.split("_1.tscn")[0]
		new_button.set_skin_name_on_button.call_deferred(truncated_name)
		v_box_container.add_child(new_button)
	SignalBusMp.swap_skin.connect(_swap_skin_model)
	_swap_skin_model("cyborg_ninja")


func _swap_skin_model(skin_name : String) -> void:
	if marker_3d.get_child_count() > 0:
		marker_3d.remove_child(marker_3d.get_child(0))
	var skin := load(SKINS_PATH + skin_name + "_1.tscn")
	marker_3d.add_child(skin.instantiate())
	SettingsMp.selected_skin_name = skin_name


func _on_go_back_button_pressed() -> void:
	SignalBusMp.open_start_screen.emit()
	queue_free()
