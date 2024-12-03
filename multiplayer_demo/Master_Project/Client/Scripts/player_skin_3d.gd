extends Node3D
class_name PLAYER_SKIN

#@onready var viking_project: Node3D = $Viking_Project
#@onready var animation_player: AnimationPlayer = $Viking_Project/AnimationPlayer
@onready var animation_player: AnimationPlayer

const SKINS_PATH = "res://Master_Project/assets/Characters/Scenes/"

var is_reflecting := false


func _ready() -> void:
	set_skin()
	var skin : Node3D = get_tree().get_first_node_in_group("skin")
	for child in skin.get_children():
		if child is AnimationPlayer:
			animation_player = child
			animation_player.animation_finished.connect(_flip_timer_timeout)


func set_skin() -> void:
	var skin := load(SKINS_PATH + SettingsMp.selected_skin_name + "_1.tscn")
	var skin_instance : Node3D = skin.instantiate()
	skin_instance.rotate_y(PI)
	add_child(skin_instance)
	skin_instance.add_to_group("skin")

func run() -> void:
	if not is_reflecting:
		animation_player.play("mixamo_anims/Run")

func idle() -> void:
	if not is_reflecting:
		animation_player.play("mixamo_anims/Idle")

func reflect() -> void:
	if not is_reflecting:
		is_reflecting = true
		animation_player.play("mixamo_anims/Backflip")
		
		#get_tree().create_timer(0.5).timeout.connect(_flip_timer_timeout)


func _flip_timer_timeout(anim_name : StringName) -> void:
	if anim_name == "mixamo_anims/Backflip":
		is_reflecting = false
