class_name Input_Manager_Client_3D extends Node

## The maximum speed the player can move at in meters per second.
@export_range(3.0, 12.0, 0.1) var max_speed := 6.0
## Controls how quickly the player accelerates and turns on the ground.
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0

var connection_manager_c: Connection_Manager_Client
@onready var player: CharacterBody3D = $".."
#@onready var character_knight_01: Node3D = $"../Character_Knight_01"
@onready var player_skin_3d: Node3D = %Player_Skin_3D

@onready var camera_3d: Camera3D = $"../Camera_Pivot_3D/Camera3D"

var buffer_manager_c: Buffer_Manager_C
var packet_manager_c: PACKET_MANAGER_C
#@onready var ghost_manager_c: Ghost_Manager_C = %Ghost_Manager_C

#var direction : Vector3
var input_buffer : Array[Vector2]
var packet_arr : Array[Dictionary]
var input_history : Array[Dictionary]
var current_packet := 0
var last_recv_packet_id := -1
var temp_packet : Dictionary

var _ground_plane := Plane(Vector3.UP)

const GRAVITY := 40.0 * Vector3.DOWN

var handle_mouse_input := true

func _init() -> void:
	set_physics_process(false)

func _ready() -> void:
	SignalBusMp.initialize_player_position_on_player.connect(init_player_position)
	packet_manager_c = get_tree().get_first_node_in_group("packet_mgr")
	
	var wrapper := get_tree().get_first_node_in_group("client_wrap")
	var siblings := wrapper.get_children()
	for s in siblings:
		if s.is_in_group("conn_mgr"):
			connection_manager_c = s
		elif s.is_in_group("buff_mgr"):
			buffer_manager_c = s
	
	set_physics_process(true)

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		if not is_node_ready():
			await ready # Wait until ready signal.
		#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		handle_mouse_input = false
	elif what == NOTIFICATION_WM_MOUSE_ENTER:
		if not is_node_ready():
			await ready
		handle_mouse_input = true
		

func update_player_authoritative_position(packet : Dictionary) -> void:
	# getting the most recent player update, cuz why not?
	if packet[connection_manager_c.player_id]["packet_id"] != packet_manager_c._last_confirmed_packet_id:
		packet_manager_c.register_confirmed_packet(packet[connection_manager_c.player_id]["packet_id"])
		#packet_manager_c._last_confirmed_packet_id = packet[connection_manager_c.player_id]["packet_id"]
		temp_packet = packet.duplicate()

func _physics_process(delta: float) -> void:
	if not is_node_ready():
		return
	if connection_manager_c.connected:
		# Calculate movement based on input and gravity.
		var input_vector : Vector2 = Input.get_vector("move_left","move_right","move_up","move_down")
		var direction : Vector3 = Vector3(input_vector.x, 0.0, input_vector.y)
		
		_ground_plane.d = player.global_position.y
		# Raycast to get the mouse position in 3D space and make the player look at it.
		var mouse_position_2d := get_viewport().get_mouse_position()
		var mouse_ray := camera_3d.project_ray_normal(mouse_position_2d)
		var world_mouse_position: Variant = _ground_plane.intersects_ray(camera_3d.global_position, mouse_ray)
		if world_mouse_position != null and handle_mouse_input:
			player_skin_3d.look_at(world_mouse_position)
			#print(world_mouse_position)
		
		# -1 represents no action command, otherwise: SettingsMp.ACTION_COMMAND_TYPE
		var action_command : int = -1
		
		# Predict player movement immediately as input comes in
		# this movement will be overwritten by the server's response
		# during the reconciliation step
		if SettingsMp.enable_client_prediction:
			client_prediction(delta, direction)
		
		# Generating serialized input packet and sending it out
		generate_input_packet(direction, action_command, player_skin_3d.rotation)
		
		# When the server sends the client a new state (position and velocity)
		# the client must apply that new state, which rewinds the player back
		# a few frames. SO we have to re-simulate the inputs from that past
		# state until now
		if !temp_packet.is_empty():
			var packet : Dictionary = temp_packet.duplicate()
			temp_packet.clear()
			# Spawn in ghost for each peer
			#ghost_manager_c.spawn_peer_characters(packet)
			
			if packet.has(connection_manager_c.player_id):
				player.position = packet[connection_manager_c.player_id]["position"]
				player.velocity = packet[connection_manager_c.player_id]["velocity"]
				
				if SettingsMp.enable_server_reconciliation:
					server_reconciliation(delta)
		
		#current_packet += 1


func client_prediction(delta: float, direction : Vector3) -> void:
	var desired_velocity : Vector3 = calculate_movement(delta, player.velocity, direction)
	player.velocity = desired_velocity
	player.move_and_slide()


func generate_input_packet(direction : Vector3, action_command: int, skin_rotation: Vector3) -> void:
	# packet manager will maintain the history of generated packets -> for reconciliation
	packet_manager_c.write_to_client_packet(direction, action_command, skin_rotation)


func server_reconciliation(delta : float) -> void:
	# Rewrite using packet manager #
	for i in range(packet_manager_c._last_confirmed_packet_id + 1, packet_manager_c._packet_history.size()):
		client_prediction(delta, packet_manager_c._packet_history[i]["input_vector"])
	# ---------------------------- #


func calculate_movement(delta : float, player_velocity_ref : Vector3, direction : Vector3) -> Vector3:
	var forward := player.global_basis.z
	var right := player.global_basis.x
	var move_direction := forward * direction.z + right * direction.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var desired_ground_velocity : Vector3 = max_speed * move_direction
	var steering_vector : Vector3 = desired_ground_velocity - player_velocity_ref
	steering_vector.y = 0.0
	
	# We limit the steering amount to ensure the velocity can never overshoots the
	# desired velocity.
	var steering_amount : float = min(steering_factor * delta, 1.0)
	player_velocity_ref += steering_vector * steering_amount
	
	player_velocity_ref += GRAVITY * delta
	
	return player_velocity_ref


func _on_prediction_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_client_prediction = toggled_on


func _on_reconciliation_check_button_toggled(toggled_on: bool) -> void:
	SettingsMp.enable_server_reconciliation = toggled_on

# Use signals to grab position from memory
func init_player_position(position: Vector3, rotation: Vector3) -> void:
	#player.position = SettingsMp.player_initial_position
	player.position = position
	player.rotation_degrees = rotation