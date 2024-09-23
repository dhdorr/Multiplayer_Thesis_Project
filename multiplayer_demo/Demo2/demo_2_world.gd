extends Node2D

## Sets the speed of the simulation.
## Lower value = slower frame processing
@export_range(0.02, 1.0, 0.01) var time_scale := 1.0
## input delay in frames
@export_range(0.0, 10.0, 1.0) var input_delay := 0.0
## Transmission delay in frames. 
## Withholds sending input buffer for x frames
@export_range(0.0, 10.0, 1.0) var transmission_delay := 0.0
## Changes tick rate for client inputs
@export_range(0.0, 2.0, 0.1) var tick_rate_factor := 1.0
## Network latency in miliseconds
@export_range(0.0, 300.0, 0.1) var network_latency := 50.0

@onready var input_manager: Node = %Input_Manager
@onready var demo_2_player_client: CharacterBody2D = %Demo2_Player_Client
@onready var network_layer: Node = %Network_Layer
@onready var demo_2_player_server: CharacterBody2D = %Demo2_Player_Server
@onready var demo_2_client_graph: Node2D = %Demo2_Client_Graph


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_time_scales()
	
	# input manager to here - the junction
	SignalBus.dump_input_buffer.connect(test_delivery)
	# the junction to the client graph
	#SignalBus.deliver_to_client_graph.connect(demo_2_client_graph.spawn_packet_icon)
	SignalBus.send_client_input_buffer.connect(demo_2_client_graph.spawn_packet_icon)
	# the junction to the client player
	SignalBus.transmit_to_client.connect(demo_2_player_client.consume_input_buffer)
	# the junction to the network layer
	SignalBus.simulate_latency.connect(network_layer.simulate_network)
	# the network layer back to the junction
	SignalBus.deliver_to_server.connect(deliver_to_server)
	# the junction to the server player
	SignalBus.transmit_to_server.connect(demo_2_player_server.consume_input_buffer)
	

func test_delivery(buff : Array[Vector2]) -> void:
	
	SignalBus.transmit_to_client.emit(buff.duplicate())
	
	## transmit to the client graph to show input packets
	#SignalBus.deliver_to_client_graph.emit(buff.duplicate())
	
	SignalBus.simulate_latency.emit(buff.duplicate())
	


func deliver_to_server(buff: Array[Vector2]) -> void:
	
	SignalBus.transmit_to_server.emit(buff.duplicate())
	

func _process(delta: float) -> void:
	if Settings.time_scale != time_scale:
		set_time_scales()
	Settings.input_delay = input_delay
	Settings.transmission_delay = transmission_delay
	Settings.network_latency = network_latency
	Settings.client_tick_rate_factor = tick_rate_factor
	
	
func set_time_scales() -> void:
	Settings.time_scale = time_scale
	Engine.time_scale = Settings.original_time_scale * Settings.time_scale
	Engine.physics_ticks_per_second = Settings.original_physics_tick_rate * time_scale
