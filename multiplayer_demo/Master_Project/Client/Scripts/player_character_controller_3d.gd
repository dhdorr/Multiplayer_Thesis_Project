extends CharacterBody3D
class_name PLAYER_CHARACTER

@onready var nameplate: Label3D = $Nameplate
@onready var player_skin_3d: PLAYER_SKIN = %Player_Skin_3D
@onready var reflect_area_3d: Area3D = $Test_Rotation_3D/Reflect_Area3D

var is_action_on_cooldown := false

func _ready() -> void:
	self.position = SettingsMp.player_initial_position
	self.rotation = SettingsMp.player_initial_rotation
	nameplate.text = SettingsMp.client_username
	player_skin_3d.idle()


func activate_reflection() -> void:
	#print(reflect_area_3d.global_basis.z)
	if not is_action_on_cooldown:
		#print("reflect activated!")
		is_action_on_cooldown = true
		get_tree().create_timer(0.5).timeout.connect(func() -> void: is_action_on_cooldown = false)
		if reflect_area_3d.get_overlapping_bodies().size() > 0:
			#print("we touchin balls!")
			SignalBusMp.player_activated_reflection.emit(reflect_area_3d.global_basis.z)
