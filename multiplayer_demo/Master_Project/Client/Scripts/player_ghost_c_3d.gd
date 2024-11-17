class_name PLAYER_GHOST_CLIENT extends CharacterBody3D

@onready var character_soldier_01: Node3D = $Character_Soldier_01

var _target_position := self.position
var _skin_rotation : Vector3

func _physics_process(delta: float) -> void:
	rotate_ghost(delta)
	move_ghost(delta)

func rotate_ghost(delta: float) -> void:
	character_soldier_01.rotation.y = lerp_angle(
		character_soldier_01.rotation.y, _skin_rotation.y, SettingsMp.get_server_tick_rate() * delta
	)

func move_ghost(delta: float) -> void:
	self.position = self.position.lerp(_target_position, SettingsMp.get_server_tick_rate() * delta)
