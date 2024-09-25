extends Control

@onready var settings_button: Button = %Settings_Button
@onready var settings_v_box: VBoxContainer = %Settings_VBox
@onready var bg_control: Control = %BG_Control
@onready var graph_check_button: CheckButton = %Graph_CheckButton

# Sliders
@onready var time_scale_h_slider: HSlider = %Time_Scale_HSlider
@onready var latency_h_slider: HSlider = %Latency_HSlider
@onready var server_buffer_h_slider: HSlider = %Server_Buffer_HSlider
@onready var client_transmission_h_slider: HSlider = %Client_Transmission_HSlider
@onready var client_input_delay_h_slider: HSlider = %Client_Input_Delay_HSlider

func _ready() -> void:
	settings_v_box.visible = false
	bg_control.visible = false
	time_scale_h_slider.value = Settings.time_scale
	latency_h_slider.value = Settings.network_latency
	
	#for n : HSlider in get_tree().get_nodes_in_group("sliders"):
		#n.drag_ended.connect(_on_slider_drag_ended)

func _on_settings_button_pressed() -> void:
	settings_v_box.visible = true
	bg_control.visible = true
	


func _on_close_button_pressed() -> void:
	settings_v_box.visible = false
	bg_control.visible = false


func _on_time_scale_h_slider_drag_ended(value_changed: bool) -> void:
	Settings.time_scale = time_scale_h_slider.value
	$Settings_VBox/VBoxContainer5/HBoxContainer/TS_Label.text = str(Settings.time_scale)
	SignalBus.update_time_scale_from_ui.emit()


func _on_latency_h_slider_drag_ended(value_changed: bool) -> void:
	Settings.network_latency = latency_h_slider.value
	$Settings_VBox/VBoxContainer/HBoxContainer/NL_Label.text = str(Settings.network_latency)


func _on_server_buffer_h_slider_drag_ended(value_changed: bool) -> void:
	Settings.server_input_buffer_time = server_buffer_h_slider.value
	$Settings_VBox/VBoxContainer2/HBoxContainer/SB_Label.text = str(Settings.server_input_buffer_time)

func _on_client_transmission_h_slider_drag_ended(value_changed: bool) -> void:
	Settings.transmission_delay = client_transmission_h_slider.value
	$Settings_VBox/VBoxContainer3/HBoxContainer/TD_Label.text = str(Settings.transmission_delay)


func _on_client_input_delay_h_slider_drag_ended(value_changed: bool) -> void:
	SignalBus.reset_input_delay.emit()
	Settings.input_delay = float(client_input_delay_h_slider.value)
	$Settings_VBox/VBoxContainer4/HBoxContainer/ID_Label.text = str(Settings.input_delay)
	print("\n input delay: ", Settings.input_delay)


func _on_graph_check_button_pressed() -> void:
	SignalBus.display_graphs.emit(graph_check_button.button_pressed)
	time_scale_h_slider.value = Settings.time_scale
	$Settings_VBox/VBoxContainer5/HBoxContainer/TS_Label.text = str(Settings.time_scale)
