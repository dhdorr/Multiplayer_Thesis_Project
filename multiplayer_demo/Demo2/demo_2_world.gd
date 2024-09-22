extends Node2D

@onready var input_manager: Node = %Input_Manager
@onready var demo_2_player_client: CharacterBody2D = %Demo2_Player_Client
@onready var network_layer: Node = %Network_Layer
@onready var demo_2_player_server: CharacterBody2D = %Demo2_Player_Server
@onready var demo_2_client_graph: Node2D = %Demo2_Client_Graph


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# input manager to here - the junction
	SignalBus.dump_input_buffer.connect(test_delivery)
	# the junction to the client player
	SignalBus.transmit_to_client.connect(demo_2_player_client.consume_input_buffer)
	SignalBus.deliver_to_client_graph.connect(demo_2_client_graph.spawn_packet_icon)
	
	# the junction to the network layer
	SignalBus.simulate_latency.connect(network_layer.simulate_network)
	# the network layer back to the junction
	SignalBus.deliver_to_server.connect(deliver_to_server)
	# the junction to the server player
	SignalBus.transmit_to_server.connect(demo_2_player_server.consume_input_buffer)
	


func test_delivery(buff : Array[Vector2]) -> void:
	
	SignalBus.transmit_to_client.emit(buff.duplicate())
	
	# transmit to the client graph to show input packets
	SignalBus.deliver_to_client_graph.emit(buff.duplicate())
	
	SignalBus.simulate_latency.emit(buff.duplicate())
	

func deliver_to_server(buff: Array[Vector2]) -> void:
	
	SignalBus.transmit_to_server.emit(buff.duplicate())
	
