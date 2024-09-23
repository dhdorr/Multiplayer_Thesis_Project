extends Node


signal dump_input_buffer(buff : Array[Vector2])
signal send_client_input_buffer(buff : Array[Vector2])
signal transmit_to_client(buff : Array[Vector2])
signal deliver_to_client_graph(buff : Array[Vector2])
signal transmit_to_server(buff : Array[Vector2])
signal simulate_latency(buff : Array[Vector2])
signal deliver_to_server(buff : Array[Vector2])
