class_name PLAYER_SKIN_SERVER extends CharacterBody3D

@onready var character_soldier_01: Node3D = $Character_Soldier_01

func rotate_skin(skin_rotation: Vector3) -> void:
	character_soldier_01.rotation = skin_rotation
