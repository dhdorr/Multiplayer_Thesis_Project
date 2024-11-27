extends CharacterBody3D

@onready var nameplate: Label3D = $Nameplate
@onready var player_skin_3d: PLAYER_SKIN = %Player_Skin_3D

func _ready() -> void:
	self.position = SettingsMp.player_initial_position
	self.rotation = SettingsMp.player_initial_rotation
	nameplate.text = SettingsMp.client_username
	player_skin_3d.idle()
