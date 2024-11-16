extends Node

signal dispense_from_buffer_manager(packets : Array[Dictionary])
signal dispense_player_update_from_buffer_manager(packet : Dictionary)

signal update_client_label

signal setup_settings_toggle(proc_type: int)

signal initialize_player_position_on_player(position: Vector3, rotation: Vector3)
