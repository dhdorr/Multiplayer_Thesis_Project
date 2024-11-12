extends Node

enum MP_PROCESS_TYPE {MP_SERVER, MP_CLIENT}

var enable_client_prediction := true
var enable_server_reconciliation := true
var enable_client_entity_interpolation := true

var server_tick_rate : int = 10

var server_to_client_latency : float = 100.0

var player_initial_position : Vector3 = Vector3.ZERO

func get_server_tick_rate() -> int:
	return 60 / server_tick_rate

func init_player_position_3D(position : Vector3):
	player_initial_position = position
