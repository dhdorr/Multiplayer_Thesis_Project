extends RigidBody3D
class_name Bomb_Ball_Server

var temp_speed := 10

func _ready() -> void:
	SignalBusMp.player_activated_reflection.connect(_reflect_the_ball)


func _physics_process(delta: float) -> void:
	#self.position += self.linear_velocity * delta
	var dir : Vector3 = self.linear_velocity.normalized()
	var collision := move_and_collide(dir * temp_speed * delta)
	if collision:
		self.linear_velocity = dir.bounce(collision.get_normal())

func move_the_ball() -> void:
	pass


func _reflect_the_ball(foreward_vector : Vector3) -> void:
	self.linear_velocity = -1 * foreward_vector.normalized() * temp_speed
