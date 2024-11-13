class_name PACKET_MANAGER_C extends Node

#static var packet_interface := CLIENT_PACKET_INTERFACE.new()

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C

static var _packet_id: int = 0
static var _packet_history: Array[Dictionary]
# If last confirmed packet id == -1, then no packet has been confirmed
static var _last_confirmed_packet_id: int = -1
static var _confirmed_packet_id_history: Array[int]

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func write_to_client_packet(input_vector: Vector3, action_command: int) -> void:
	var packet := CLIENT_PACKET_INTERFACE.new(
		_packet_id, 
		connection_manager_c.player_id, 
		input_vector, 
		action_command
		)
	
	append_to_packet_history(packet)
	connection_manager_c.send_input_3D(packet)
	
	_packet_id += 1


func append_to_packet_history(packet: CLIENT_PACKET_INTERFACE) -> void:
	var packet_dict : Dictionary = { 
		"player_id": packet._player_id, 
		"packet_id": packet._packet_id, 
		"input_vector": packet._input_vector,
		}
	_packet_history.append(packet_dict)
	#print(_packet_history)


func register_confirmed_packet(id: int) -> void:
	_last_confirmed_packet_id = id
