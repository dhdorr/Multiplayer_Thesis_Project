extends Node


var direction : Vector2
var input_buffer : Array[Vector2] = [Vector2.ZERO]
var delay_inc := 0.0
var t_delay_inc := 0.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	input_buffer.append(direction)
	
	# emit buffer when transmission delay expires
	if delay_inc >= Settings.transmission_delay * delta:
		SignalBus.send_client_input_buffer.emit(input_buffer.duplicate())
		t_delay_inc = 0.0
	
	if delay_inc >= Settings.input_delay * delta:
		SignalBus.dump_input_buffer.emit(input_buffer.duplicate())
		delay_inc = 0.0
		input_buffer.clear()
	
	delay_inc += delta
	t_delay_inc += delta


# Maybe I should just use the Input method to get inputs whenever
# they happen? That way I can maintain a buffer of inputs that
# gets consumed once a timer times-out?
# ex:	fn Input -> input_buffer.append( new_input )
#	fn _physics_process -> if (input_buffer not empty): apply(input_buffer)
