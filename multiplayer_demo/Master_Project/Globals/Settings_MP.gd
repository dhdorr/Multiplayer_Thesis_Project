extends Node

enum MP_PROCESS_TYPE { MP_SERVER, MP_CLIENT }
enum ACTION_COMMAND_TYPE { NONE, JUMP, REFLECT, SHOOT }
enum GLOBAL_LOBBY_STATUS { OPEN, CLOSED, START_MATCH}
enum CLIENT_PACKET_TYPES { NONE, CONNECTION_REQUEST, INPUT_PACKET, LOBBY_READY_UP }
enum SERVER_PACKET_TYPES { NONE, CONNECTION_RESPONSE, LOBBY_UPDATE, WORLD_STATE_UPDATE }
enum PLAYER_SKIN_ID { NONE, VIKING, WARRIOR, KNIGHT }

var protocol_version : String = "0.0.1"

var enable_client_prediction := true
var enable_server_reconciliation := true
var enable_client_entity_interpolation := true
var enable_client_dead_reckoning := true

var server_tick_rate : int = 10

var server_to_client_latency : float = 100.0

var player_initial_position : Vector3 = Vector3.ZERO
var player_initial_rotation : Vector3 = Vector3.ZERO

func get_server_tick_rate() -> int:
	return 60 / server_tick_rate

func init_player_orientation_3D(position : Vector3, rotation : Vector3):
	player_initial_position = position
	player_initial_rotation = rotation


var client_username : String = "John Wick"
var client_passcode : String = "hello, world!"
var server_ip_address : String = "127.0.0.1"

var ball_influenced_by_player := false
