extends RigidBody3D
class_name Bomb_Ball_Server

var temp_speed := 10
var bounce_sound_fx_playing := false

func _ready() -> void:
	SignalBusMp.player_activated_reflection.connect(_reflect_the_ball)
	#$AudioStreamPlayer3D.play()


func _physics_process(delta: float) -> void:
	#self.linear_velocity = Vector3.ZERO
	#self.position += self.linear_velocity * delta
	var dir : Vector3 = self.linear_velocity.normalized()
	var collision := move_and_collide(dir * temp_speed * delta)
	if collision:
		
		if not bounce_sound_fx_playing:
			bounce_sound_fx_playing = true
			$AudioStreamPlayer.play()
		
		self.linear_velocity = dir.bounce(collision.get_normal())


func move_the_ball(init_vel : Vector3) -> void:
	self.linear_velocity = init_vel


func _reflect_the_ball(foreward_vector : Vector3) -> void:
	self.linear_velocity = -1 * foreward_vector.normalized() * temp_speed
	temp_speed += 2


func forward_simulate(frame_count : int) -> void:
	for f in frame_count:
		var dir : Vector3 = self.linear_velocity.normalized()
		var collision := move_and_collide(dir * temp_speed * get_physics_process_delta_time())
		if collision:
			self.linear_velocity = dir.bounce(collision.get_normal())


func _on_audio_stream_player_finished() -> void:
	bounce_sound_fx_playing = false
