extends Control

signal back_requested

## CLAUDE
 
@onready var res_720_button: Button = $VBoxContainer/Resolutions/Res720
@onready var res_1080_button: Button = $VBoxContainer/Resolutions/Res1080
@onready var res_1440_button: Button = $VBoxContainer/Resolutions/Res1440
@onready var fullscreen_button: CheckButton = $VBoxContainer/FullscreenButton
@onready var back_button: Button = $VBoxContainer/BackButton
 
var resolution_buttons: Array
 
func _ready() -> void:
	resolution_buttons = [res_720_button, res_1080_button, res_1440_button]
 
	fullscreen_button.button_pressed = GameSettings.fullscreen
	_highlight_resolution(GameSettings.resolution_index)
	_update_resolution_buttons_enabled()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		back_requested.emit()
 
func _on_res_720_pressed() -> void:
	_select_resolution(0)
 
func _on_res_1080_pressed() -> void:
	_select_resolution(1)
 
func _on_res_1440_pressed() -> void:
	_select_resolution(2)
 
func _select_resolution(index: int) -> void:
	GameSettings.resolution_index = index
	_highlight_resolution(index)
	if not GameSettings.fullscreen:
		GameSettings.apply_display_settings()
 
func _highlight_resolution(index: int) -> void:
	var selected_color = Color.CYAN
	var normal_color = Color.WHITE
	for i in resolution_buttons.size():
		resolution_buttons[i].modulate = selected_color if i == index else normal_color
 
func _on_fullscreen_button_toggled(pressed: bool) -> void:
	GameSettings.fullscreen = pressed
	GameSettings.apply_display_settings()
	_update_resolution_buttons_enabled()
 
func _update_resolution_buttons_enabled() -> void:
	# Picking a windowed resolution doesn't mean anything while fullscreen.
	for button in resolution_buttons:
		button.disabled = GameSettings.fullscreen
 
func _on_back_button_pressed() -> void:
	back_requested.emit()

func grab_default_focus():
	back_button.grab_focus()
