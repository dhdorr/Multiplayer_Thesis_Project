extends Node3D

@onready var viking_project: Node3D = $Viking_Project
@onready var animation_player: AnimationPlayer = $Viking_Project/AnimationPlayer

func run():
	animation_player.play("Viking_Jog")

func idle():
	animation_player.play("Viking_Idle")
