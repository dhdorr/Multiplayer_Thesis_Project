class_name PLAYER_SKIN_SERVER extends CharacterBody3D

#@onready var character_soldier_01: Node3D = $Character_Soldier_01
@onready var ghost_skin_3d: Node3D = %Ghost_Skin_3D

func rotate_skin(skin_rotation: Vector3) -> void:
	ghost_skin_3d.rotation = skin_rotation
