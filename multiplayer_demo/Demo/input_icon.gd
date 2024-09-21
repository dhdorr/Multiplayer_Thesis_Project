extends Sprite2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func anim(anim_name: String) -> void:
	animation_player.play(anim_name)
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
