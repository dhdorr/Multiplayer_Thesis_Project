class_name PLAYER_GHOST_CLIENT extends CharacterBody3D

#@onready var character_soldier_01: Node3D = $Character_Soldier_01
@onready var ghost_skin_3d: Node3D = %Ghost_Skin_3D
@onready var warrior_project: Node3D = $Ghost_Skin_3D/Warrior_Project
@onready var animation_player: AnimationPlayer
#@onready var animation_player: AnimationPlayer = $Ghost_Skin_3D/Warrior_Project/AnimationPlayer
@onready var nameplate: Label3D = $Nameplate

const SKINS_PATH = "res://Master_Project/assets/Characters/Scenes/"

var _target_position := self.position
var _prev_target_position := Vector3.ZERO
var _skin_rotation : Vector3
var _last_input := Vector3.ZERO
var _last_action := SettingsMp.ACTION_COMMAND_TYPE.NONE
var _is_reflecting := false
var _is_dead := false


func _physics_process(delta: float) -> void:
	if _last_input == Vector3.ZERO and not _is_reflecting:
		animation_player.play("mixamo_anims/Idle")
		#print("idle")
	elif _last_input != Vector3.ZERO and not _is_reflecting:
		animation_player.play("mixamo_anims/Run")
		#print("run")
	
	if _last_action == SettingsMp.ACTION_COMMAND_TYPE.REFLECT:
		_is_reflecting = true
		animation_player.play("mixamo_anims/Backflip")
	
	rotate_ghost(delta)
	move_ghost(delta)


func do_flip() -> void:
	_is_reflecting = true
	animation_player.play("mixamo_anims/Backflip")


func _flip_timer_timeout(anim_name : StringName) -> void:
	if anim_name == "mixamo_anims/Backflip":
		_is_reflecting = false
		print("not reflecting - ghost")


func rotate_ghost(delta: float) -> void:
	if SettingsMp.enable_client_entity_interpolation:
		ghost_skin_3d.rotation.y = lerp_angle(
			ghost_skin_3d.rotation.y, _skin_rotation.y, SettingsMp.get_server_tick_rate() * delta
		)
	else:
		ghost_skin_3d.rotation.y = _skin_rotation.y

func move_ghost(delta: float) -> void:
	if SettingsMp.enable_client_entity_interpolation:
		#self.position = self.position.lerp(_target_position, SettingsMp.get_server_tick_rate() * delta)
		self.position = self.position.move_toward(_target_position, SettingsMp.get_server_tick_rate() * delta)
	else:
		self.position = _target_position


func activate_death() -> void:
	if not _is_dead:
		ghost_skin_3d.visible = false
		_is_dead = true
		print("this ghost is dead")
		$GPUParticles3D.emitting = true
		#get_tree().create_timer(0.5).timeout.connect(func()->void:
			#$GPUParticles3D.emitting = false
			#)



func set_skin(skin_id : int) -> void:
	var skin_name : String = "cyborg_ninja"
	match skin_id:
		SettingsMp.PLAYER_SKIN_ID.BARD:
			skin_name = "bard"
		SettingsMp.PLAYER_SKIN_ID.CYBORG:
			skin_name = "cyborg_ninja"
		SettingsMp.PLAYER_SKIN_ID.DRUID:
			skin_name = "druid"
		SettingsMp.PLAYER_SKIN_ID.KING:
			skin_name = "king"
		SettingsMp.PLAYER_SKIN_ID.QUEEN:
			skin_name = "queen"
		SettingsMp.PLAYER_SKIN_ID.ROGUE:
			skin_name = "rogue"
		SettingsMp.PLAYER_SKIN_ID.SAMURAI:
			skin_name = "samurai"
		SettingsMp.PLAYER_SKIN_ID.SORCERER:
			skin_name = "sorcerer"
		SettingsMp.PLAYER_SKIN_ID.WITCH:
			skin_name = "witch"
		SettingsMp.PLAYER_SKIN_ID.WIZARD:
			skin_name = "wizard"
	var skin := load(SKINS_PATH + skin_name + "_1.tscn")
	var skin_instance : Node3D = skin.instantiate()
	skin_instance.rotate_y(PI)
	ghost_skin_3d.add_child(skin_instance)
	for child in skin_instance.get_children():
		if child is AnimationPlayer:
			animation_player = child
			animation_player.animation_finished.connect(_flip_timer_timeout)
