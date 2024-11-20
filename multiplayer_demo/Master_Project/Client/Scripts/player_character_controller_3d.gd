extends CharacterBody3D

func _ready() -> void:
	self.position = SettingsMp.player_initial_position
	self.rotation = SettingsMp.player_initial_rotation
