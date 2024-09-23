extends Node

var time_scale := 1.0
var input_delay := 1.0
var transmission_delay := 0.0
var network_latency := 50.0
var client_tick_rate_factor := 1.0
var server_input_buffer_time := 1.0

var original_time_scale := Engine.time_scale
var original_physics_tick_rate := Engine.physics_ticks_per_second

var max_fps := 60.0
var time_line_length := 60.0 * 64.0 


func get_network_latency_seconds() -> float:
	return network_latency / 1000.0

func get_input_delay_seconds() -> float:
	return input_delay / (client_tick_rate_factor * max_fps)

func get_transmission_delay_seconds() -> float:
	return transmission_delay / (client_tick_rate_factor * max_fps)

func get_server_buffer_time_seconds() -> float:
	return server_input_buffer_time / (max_fps)
