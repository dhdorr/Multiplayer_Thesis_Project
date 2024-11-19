class_name PLAYER_GHOST_CLIENT extends CharacterBody3D

#@onready var character_soldier_01: Node3D = $Character_Soldier_01
@onready var ghost_skin_3d: Node3D = %Ghost_Skin_3D
@onready var warrior_project: Node3D = $Ghost_Skin_3D/Warrior_Project
@onready var animation_player: AnimationPlayer = $Ghost_Skin_3D/Warrior_Project/AnimationPlayer

var _target_position := self.position
var _prev_target_position := Vector3.ZERO
var _skin_rotation : Vector3
var _last_input := Vector3.ZERO

func _physics_process(delta: float) -> void:
	if _last_input == Vector3.ZERO:
		animation_player.play("Warrior_Idle")
		#print("idle")
	else:
		animation_player.play("Warrior_Run")
		#print("run")
	
	rotate_ghost(delta)
	move_ghost(delta)

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
