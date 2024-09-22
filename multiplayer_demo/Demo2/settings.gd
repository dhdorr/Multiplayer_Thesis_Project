extends Node

var time_scale := 0.0
var input_delay := 0.0
var network_latency := 0.0

var original_time_scale := Engine.time_scale
var original_physics_tick_rate := Engine.physics_ticks_per_second


func get_network_latency_seconds() -> float:
	return network_latency / 1000.0
