class_name PACKET_MANAGER_C extends Node

#static var packet_interface := CLIENT_PACKET_INTERFACE.new()

@onready var connection_manager_c: Connection_Manager_Client = %Connection_Manager_C

static var _packet_id: int = 0
static var _packet_history: Array[Dictionary]
var _packet_history_2: Array[CLIENT_PACKET_INTERFACE]
# If last confirmed packet id == -1, then no packet has been confirmed
static var _last_confirmed_packet_id: int = -1
static var _confirmed_packet_id_history: Array[int]

# Reusing the same packet to avoid memory usage
@onready var packet := CLIENT_PACKET_INTERFACE.new(-1, -1, Vector3.INF, SettingsMp.ACTION_COMMAND_TYPE.NONE)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func write_to_client_packet(input_vector: Vector3, action_command: int) -> void:
	#var packet := CLIENT_PACKET_INTERFACE.new(
		#_packet_id, 
		#connection_manager_c.player_id, 
		#input_vector, 
		#action_command
		#)
	packet._player_id = connection_manager_c.player_id
	packet._packet_id = _packet_id
	packet._input_vector = input_vector
	packet._action_command = action_command
	# I wanted to use the interface class but godot's class implementation is not meant for networking :(
	# I am forced to use a basic type, like a dictionary
	var packet_dict : Dictionary = packet.packet_as_dict()
	append_to_packet_history(packet_dict)
	connection_manager_c.send_input_3D(packet_dict)
	
	_packet_id += 1


func append_to_packet_history(packet_d: Dictionary) -> void:
	_packet_history.append(packet_d)


func register_confirmed_packet(id: int) -> void:
	_last_confirmed_packet_id = id
