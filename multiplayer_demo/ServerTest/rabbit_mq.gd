extends Node2D

var _rmq_client : RMQClient
var _channel : RMQChannel
var queue_name := "hello"

var test_dict : Dictionary = {"foo": "bar",}
#var test_dict : Vector2 = Vector2(1,1)

func _ready() -> void:
	test_dict["num"] = randi_range(0, 10)
	queue_name = queue_name + str(test_dict["num"])
	
	_rmq_client = RMQClient.new()
	
	var client_open_error := await _rmq_client.open(
		"localhost",
		5672,
		"guest",
		"guest")
	
	if client_open_error != OK:
		print_debug(client_open_error)
		return
	
	
	
	_channel = await _rmq_client.channel()
	var queue_declare := await _channel.queue_declare(queue_name)
	if queue_declare[0] != OK:
		print_debug(queue_declare)
		return
	
	var exchange_declare := await _channel.exchange_declare("test", "fanout")
	if exchange_declare != OK:
		print_debug(exchange_declare)
		return
	_channel.queue_bind(queue_name, "test")
	
	var consume = await _channel.basic_consume(queue_name, 
		func(channel:RMQChannel, method:RMQBasicClass.Deliver, properties:RMQBasicClass.Properties, body:PackedByteArray):
			print("got message ", body.get_string_from_utf8())
			channel.basic_ack(method.delivery_tag)
			
			var temp_variant = bytes_to_var(body)
			var my_dict = type_convert(temp_variant, TYPE_DICTIONARY)
			var my_vec = type_convert(temp_variant, TYPE_VECTOR2)
			
			if type_convert(temp_variant, TYPE_VECTOR2) != Vector2.ZERO:
				print("vector type: ", temp_variant)
			elif type_convert(temp_variant, TYPE_DICTIONARY) != {}:
				print("dictionary type: ", temp_variant)
			,)
	
	if consume[0] != OK:
		print_debug(queue_declare)
		return
	

func _process(delta: float) -> void:
	_rmq_client.tick()
	
	if _channel and Input.is_action_just_pressed("fire_projectile"):
		
		var publishing_error := await _channel.basic_publish("test", queue_name, var_to_bytes(test_dict))
		
		if publishing_error != OK:
			print_debug(publishing_error)
			return

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_rmq_client.close()
