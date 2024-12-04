extends Node

var database : SQLite

# how to insert dates
#INSERT INTO datetime_text (d1, d2)
#VALUES(datetime('now'),datetime('now', 'localtime'));

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()
	
	var pragma_query_strings : String = "PRAGMA journal_mode = wal; PRAGMA foreign_keys = ON;"
	database.query(pragma_query_strings)
	
	var query_string : String = "CREATE TABLE IF NOT EXISTS players (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		player_id INTEGER UNIQUE,
		player_ip TEXT NOT NULL,
		player_port INTEGER NOT NULL,
		username TEXT NOT NULL
		);"
	database.query(query_string)
	
	var query_string_matches : String = "CREATE TABLE IF NOT EXISTS matches (
		match_id INTEGER PRIMARY KEY AUTOINCREMENT,
		date_played TEXT NOT NULL
		);"
	database.query(query_string_matches)
	
	var query_string_match_players : String = "CREATE TABLE IF NOT EXISTS match_players (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		match_id INTEGER NOT NULL,
		player_id INTEGER NOT NULL,
		FOREIGN KEY (player_id)
			REFERENCES players (player_id),
		FOREIGN KEY (match_id)
			REFERENCES matches (match_id)
		);"
	database.query(query_string_match_players)
	
	var query_string_1 : String = "CREATE TABLE IF NOT EXISTS client_input_packets (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		player_id INTEGER NOT NULL,
		packet_id INTEGER NOT NULL,
		version_id TEXT NOT NULL,
		direction TEXT NOT NULL,
		rotation TEXT NOT NULL,
		action_command INTEGER NOT NULL,
		match_id INTEGER NOT NULL,
		FOREIGN KEY (player_id)
			REFERENCES players (player_id),
		FOREIGN KEY (match_id)
			REFERENCES matches (match_id)
		);"
	database.query(query_string_1)
	
	var query_string_2 : String = "CREATE TABLE IF NOT EXISTS server_world_update_packets (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		player_states TEXT NOT NULL,
		bomb_ball_state TEXT NOT NULL,
		server_update_id INTEGER NOT NULL,
		version TEXT NOT NULL,
		match_id INTEGER NOT NULL,
		FOREIGN KEY (match_id)
			REFERENCES matches (match_id)
		);"
	database.query(query_string_2)


func write_client_packet_to_table(packet : Dictionary) -> void:
	var data : Dictionary = {
		"player_id" = int(packet["player_id"]),
		"packet_id" = int(packet["packet_id"]),
		"version_id" = str(packet["version"]),
		"direction" = str(packet["direction"]),
		"rotation" = str(packet["rotation"]),
		"action_command" = int(packet["action_command"]),
		"match_id" = int(%Connection_Manager_S.curr_match_id),
	}
	database.insert_row("client_input_packets", data)


# TODO Add Robustness
func write_server_world_update_to_table(packet : Dictionary) -> void:
	var data : Dictionary = {
			"player_states" = str(packet["player_states"]),
			"bomb_ball_state" = str(packet["bomb_ball_state"]),
			"server_update_id" = int(packet["server_update_id"]),
			"version" = str(packet["version"]),
			"match_id" = int(%Connection_Manager_S.curr_match_id),
		}
	database.insert_row("server_world_update_packets", data)


func create_new_player(player : Dictionary) -> int:
	var query_string : String = "INSERT INTO players (player_id, player_ip, player_port, username)
		VALUES (
			(SELECT player_id FROM players ORDER BY id DESC LIMIT 1) + 1,
			'%s', '%s', '%s'
		);
		SELECT player_id FROM players ORDER BY id DESC LIMIT 1;"
	var query_string_formatted : String = query_string % [ str(player["player_ip"]), str(player["player_port"]), str(player["username"]) ]
	database.query(query_string_formatted)
	var player_id : int = database.query_result[0]["player_id"]
	return player_id


func create_new_match() -> int:
	var query_string : String = "INSERT INTO matches (date_played) VALUES (datetime('now'));
	SELECT match_id FROM matches ORDER BY match_id DESC LIMIT 1;"
	database.query(query_string)
	print(database.query_result)
	var match_id : int = database.query_result[0]["match_id"]
	return match_id


func add_player_to_match(match_id : int, player_id : int) -> void:
	var data : Dictionary = {
		"match_id" = match_id,
		"player_id" = player_id,
	}
	database.insert_row("match_players", data)
