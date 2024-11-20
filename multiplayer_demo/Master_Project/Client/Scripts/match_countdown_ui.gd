extends Control

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	SignalBusMp.start_match_countdown_animation.connect(_play_countdown)

func _play_countdown() -> void:
	animation_player.play("countdown_animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "countdown_animation":
		SignalBusMp.update_client_state.emit(Client_Wrapper.CLIENT_STATE_TYPES.PLAYING_GAME)
		queue_free()
