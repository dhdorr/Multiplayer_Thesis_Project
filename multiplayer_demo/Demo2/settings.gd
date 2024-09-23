extends Node

var time_scale := 0.0
var input_delay := 0.0
var network_latency := 0.0

var original_time_scale := Engine.time_scale
var original_physics_tick_rate := Engine.physics_ticks_per_second

var max_fps := 60.0
var time_line_length := 60.0 * 80.0 


func get_network_latency_seconds() -> float:
	return network_latency / 1000.0

func get_input_delay_secods() -> float:
	# input delay in frames * frame time in ms / 1000 ms per second
	return input_delay * 16.667 / 1000.0
