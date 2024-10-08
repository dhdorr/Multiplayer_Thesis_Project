extends Node

var enable_client_prediction := true
var enable_server_reconciliation := true

var server_tick_rate : int = 10

var server_to_client_latency : float = 100.0

func get_server_tick_rate() -> int:
	return 60 / server_tick_rate
