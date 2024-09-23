extends Node


var direction : Vector2
var input_buffer : Array[Vector2] = [Vector2.ZERO]
var transmit_input_buffer : Array[Vector2] = [Vector2.ZERO]
var delay_inc := 0.0
var t_delay_inc := 0.0

#func _ready() -> void:
	#set_physics_process(false)
	#get_tree().create_timer(0.1).timeout.connect(func() -> void: set_physics_process(true))

func _physics_process(delta: float) -> void:
	
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	input_buffer.append(direction)
	transmit_input_buffer.append(direction)
	
	t_delay_inc += delta
	delay_inc += delta
	
	SignalBus.client_frame_procesed.emit()
	# emit buffer when transmission delay expires
	if t_delay_inc > Settings.transmission_delay * delta:
		# transmit over the network
		SignalBus.client_transmission_delay_expired.emit(transmit_input_buffer.duplicate())
		t_delay_inc = 0.0
		transmit_input_buffer.clear()
	
	if delay_inc > Settings.input_delay * delta:
		# dump input to client player for prediction
		SignalBus.client_input_delay_expired.emit(input_buffer.duplicate())
		delay_inc = 0.0
		input_buffer.clear()
	
	
	


# Maybe I should just use the Input method to get inputs whenever
# they happen? That way I can maintain a buffer of inputs that
# gets consumed once a timer times-out?
# ex:	fn Input -> input_buffer.append( new_input )
#	fn _physics_process -> if (input_buffer not empty): apply(input_buffer)
