extends Node2D

### Sets the speed of the simulation.
### Lower value = slower frame processing.
### Use this for watching the network graphs
#@export_range(0.02, 1.0, 0.01) var time_scale := 1.0
### Client-side input delay in frames.
### Inputs are stored into a buffer that is consumed after this delay
#@export_range(0.0, 10.0, 1.0) var input_delay := 0.0
### Transmission delay in frames. 
### Witholds sending input buffer for the set amount of frames
#@export_range(0.0, 10.0, 1.0) var transmission_delay := 0.0
### Changes tick rate for client inputs.
### Inversly scales client-side physics_process tick delta.
### 1.0 = 60FPS, 1.5 = 90FPS
#@export_range(0.0, 2.0, 0.1) var tick_rate_factor := 1.0
### Network latency in miliseconds.
### The time it takes for packets to travel across the network
#@export_range(0.0, 300.0, 0.1) var network_latency := 50.0
### Server-side receipt buffer in frames.
### Inputs are stored into a buffer that is consumed after this delay
#@export_range(0.0, 5.0, 1.0) var server_input_buffer := 1.0

@onready var input_manager: Node = %Input_Manager
@onready var demo_2_player_client: CharacterBody2D = %Demo2_Player_Client
@onready var network_layer: Node = %Network_Layer
@onready var demo_2_player_server: CharacterBody2D = %Demo2_Player_Server
@onready var demo_2_client_graph: Node2D = %Demo2_Client_Graph

var showing_graph := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	demo_2_client_graph.visible = false
	set_time_scales()
	display_settings()
	
	%Settings_UI_Control.visible = true
	
	SignalBus.display_graphs.connect(show_graphs)
	SignalBus.update_time_scale_from_ui.connect(set_time_scales)
	SignalBus.reset_input_delay.connect(reset_input_delay)
	
	# Every frame that client input is processed, spawn a graph icon
	SignalBus.client_frame_procesed.connect(demo_2_client_graph.spawn_packet_icon)
	# When client input delay expires, send buffered input directly to client player for prediction
	SignalBus.client_input_delay_expired.connect(demo_2_player_client.consume_input_buffer)
	# When client transmission delay expires, send buffered input to the network layer
	SignalBus.client_transmission_delay_expired.connect(network_layer.simulate_network)
	# Emitted from network layer, spawns a network packet icon in the client graph
	SignalBus.spawn_client_graph_network_packet.connect(demo_2_client_graph.spawn_networked_packet_icon)
	# Emitted from the network layer, transmits input buffer to server player for consumption
	SignalBus.transmit_input_buffer_to_server.connect(demo_2_player_server.add_to_input_buffer)
	
func _physics_process(delta: float) -> void:
	%Net_Latency_Label.text = "Network Latency: " + str(Settings.network_latency)
	%Time_Scale_Label2.text = "Time Scale: " + str(Settings.time_scale)
	%Input_Delay_Label3.text = "Input Delay: " + str(Settings.input_delay)
	%Server_Buffer_Label4.text = "Server Buffer: " + str(Settings.server_input_buffer_time)
	%Transmission_Delay_Label4.text = "Transmission Delay: " + str(Settings.transmission_delay)



func set_time_scales() -> void:
	#Settings.time_scale = time_scale
	Engine.time_scale = Settings.original_time_scale * Settings.time_scale
	Engine.physics_ticks_per_second = Settings.original_physics_tick_rate * Settings.time_scale
	

func show_graphs(is_visible : bool) -> void:
	if is_visible:
		demo_2_client_graph.visible = is_visible
		Settings.time_scale = 0.02
	else:
		demo_2_client_graph.visible = is_visible
		Settings.time_scale = 1.0
	
	set_time_scales()

func display_settings() -> void:
	return
	print(Settings.time_scale)
	print(Settings.network_latency)
	print(Settings.server_input_buffer_time)
	print(Settings.input_delay)
	print(Settings.transmission_delay)
	
func reset_input_delay() -> void:
	SignalBus.client_input_delay_expired.disconnect(demo_2_player_client.consume_input_buffer)
	get_tree().create_timer(0.02).timeout.connect(func() -> void: 
		demo_2_player_client.clear_input_buffer()
		SignalBus.client_input_delay_expired.connect(demo_2_player_client.consume_input_buffer)
		)
