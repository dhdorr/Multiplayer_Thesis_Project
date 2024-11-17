class_name PLAYER_GHOST_CLIENT extends CharacterBody3D

#@onready var character_soldier_01: Node3D = $Character_Soldier_01
@onready var ghost_skin_3d: Node3D = %Ghost_Skin_3D

var _target_position := self.position
var _skin_rotation : Vector3

func _physics_process(delta: float) -> void:
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
		self.position = self.position.lerp(_target_position, SettingsMp.get_server_tick_rate() * delta)
	else:
		self.position = _target_position
