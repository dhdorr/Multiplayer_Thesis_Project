extends Sprite2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func anim(anim_name: String) -> void:
	animation_player.play(anim_name)
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
