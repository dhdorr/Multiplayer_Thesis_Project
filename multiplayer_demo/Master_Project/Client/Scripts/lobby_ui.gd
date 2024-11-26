extends Control
class_name LOBBY_UI

const PLAYER_LOBBY_NAMEPLATE = preload("res://Master_Project/Client/Scenes/player_lobby_nameplate.tscn")

@onready var nameplate_container: VBoxContainer = $VBoxContainer/Control/VBoxContainer
var connection_manager_c : Connection_Manager_Client

var lobby_player_list : Array[Dictionary]
var nameplates : Array[MarginContainer]

func _ready() -> void:
	SignalBusMp.update_client_lobby.connect(_update_lobby_ui)
	connection_manager_c = get_tree().get_first_node_in_group("conn_mgr")


func _update_lobby_ui(player_list : Array[Dictionary]) -> void:
	for player in player_list:
		# loop through packet, check to see if the nameplate exists, if not, create it
		_create_new_nameplates(player)
		_update_existing_nameplates(player)


func _create_new_nameplates(player : Dictionary) -> void:
	var should_create_nameplate : bool = true
	for existing_player in lobby_player_list:
		if player["player_id"] == existing_player["player_id"]:
			should_create_nameplate = false
			break
	if should_create_nameplate:
		lobby_player_list.append(player)
		var nameplate := PLAYER_LOBBY_NAMEPLATE.instantiate()
		nameplate_container.add_child(nameplate)
		nameplates.append(nameplate)
		var is_owner := false
		if player["player_id"] == connection_manager_c.player_id:
			is_owner = true
		nameplate.set_up_nameplate(player["player_id"], player["username"], player["is_ready"], is_owner)


func _update_existing_nameplates(player : Dictionary) -> void:
	for existing_nameplate : PLAYER_NAMEPLATE in nameplates:
		if existing_nameplate.owning_player_id == player["player_id"]:
			var is_owner := false
			if player["player_id"] == connection_manager_c.player_id:
				is_owner = true
			existing_nameplate.set_ready_state(player["is_ready"], is_owner)
