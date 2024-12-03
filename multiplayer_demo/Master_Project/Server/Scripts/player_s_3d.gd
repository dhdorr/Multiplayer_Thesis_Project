class_name PLAYER_SKIN_SERVER extends CharacterBody3D

#@onready var character_soldier_01: Node3D = $Character_Soldier_01
@onready var ghost_skin_3d: Node3D = %Ghost_Skin_3D
@onready var reflect_area_3d: Area3D = $Ghost_Skin_3D/Reflect_Area3D
@onready var hurtbox_area_3d: Area3D = %Hurtbox_Area3D


var is_action_on_cooldown : bool = false
var is_reflecting : bool = false
var is_dead : bool = false

func _physics_process(delta: float) -> void:
	if is_reflecting:
		if reflect_area_3d.get_overlapping_bodies().size() > 0:
			#print("we touchin balls!")
			SignalBusMp.player_activated_reflection.emit(reflect_area_3d.global_basis.z)
			is_reflecting = false


func rotate_skin(skin_rotation: Vector3) -> void:
	ghost_skin_3d.rotation = skin_rotation


func activate_reflection() -> void:
	#print(reflect_area_3d.global_basis.z)
	if not is_action_on_cooldown:
		#print("reflect activated!")
		is_action_on_cooldown = true
		is_reflecting = true
		get_tree().create_timer(1.0).timeout.connect(func() -> void:
			is_action_on_cooldown = false
			)
		get_tree().create_timer(0.33).timeout.connect(func() -> void:
			is_reflecting = false
			)
		if reflect_area_3d.get_overlapping_bodies().size() > 0:
			#print("we touchin balls!")
			SignalBusMp.player_activated_reflection.emit(reflect_area_3d.global_basis.z)


func _on_hurtbox_area_3d_area_entered(area: Area3D) -> void:
	print("you are dead!")
	is_dead = true
	hurtbox_area_3d.area_entered.disconnect(_on_hurtbox_area_3d_area_entered)
