extends Node


#signal dump_input_buffer(buff : Array[Vector2])
#signal send_client_input_buffer(buff : Array[Vector2])
#signal transmit_to_client(buff : Array[Vector2])
#signal deliver_to_client_graph(buff : Array[Vector2])
#signal transmit_to_server(buff : Array[Vector2])
#signal simulate_latency(buff : Array[Vector2])
#signal deliver_to_server(buff : Array[Vector2])

# refactor names
signal client_frame_procesed
signal client_input_delay_expired(buff : Array[Vector2])
signal client_transmission_delay_expired(buff : Array[Vector2])
signal spawn_client_graph_input_packet(buff : Array[Vector2])
signal spawn_client_graph_network_packet(buff : Array[Vector2])
signal transmit_input_buffer_to_server(buff : Array[Vector2])

signal display_graphs
signal update_time_scale_from_ui
signal reset_input_delay
