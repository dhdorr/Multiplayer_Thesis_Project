extends CharacterBody3D

@onready var nameplate: Label3D = $Nameplate

func _ready() -> void:
	self.position = SettingsMp.player_initial_position
	self.rotation = SettingsMp.player_initial_rotation
	nameplate.text = SettingsMp.client_username
