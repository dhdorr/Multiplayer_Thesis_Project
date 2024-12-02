extends Node

signal dispense_from_buffer_manager(packets : Array[Dictionary])
signal dispense_player_update_from_buffer_manager(packet : Dictionary)


signal setup_settings_toggle(proc_type: int)

# Client-side signals #
signal update_client_label
signal initialize_player_position_on_player(position: Vector3, rotation: Vector3)
signal update_client_state
signal start_match_countdown_animation
signal player_id_received(id: int)
signal update_client_lobby(player_list : Array[Dictionary])
signal client_ready_up(is_ready : bool)
signal swap_skin(skin_name : String)
signal open_start_screen
signal open_skin_selection
# ------------------- #

# Server-side signals #
signal update_peer_count(count: int)
signal lobby_start_match
signal player_activated_reflection
# ------------------- #
