extends Control

@export var player_count_button: Button
@export var win_limit_button: Button
@export var start_button: Button

@export var tutorial_select: Button
@export var bitematch_select: Button
@export var elimination_select: Button

@export var error_label: Label

var win_limit 
var player_count
var gamemode_scenes
var gamemode_selected_scene
var gamemode_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamemode_scenes = GameSettings.gamemode_scenes
	gamemode_selected = GameSettings.gamemode_selected
	player_count = GameSettings.player_count
	win_limit = GameSettings.win_limits[gamemode_selected]
	BackgroundMusic.play()
	start_button.grab_focus()
	
	select_gamemode(gamemode_selected)
	player_count_button.text = str(player_count)
	win_limit_button.text = str(win_limit)


func _process(delta):
	pass

func _on_start_button_pressed() -> void:
	player_count = int(player_count_button.text)
	win_limit = int(win_limit_button.text)
	
	GameSettings.player_count = player_count
	
	var connected_joypads = Input.get_connected_joypads().size()
		
	
	if player_count > connected_joypads:
		error_label.text = "Only %d controllers detected!" % (connected_joypads)
		error_label.queue_redraw()
		#error_label.shake()
		start_button.grab_focus()
		accept_event()
		return
	
	GameSettings.gamemode_selected = gamemode_selected
	ScoreManager.gamemode = gamemode_selected
	
	GameSettings.win_limits[gamemode_selected] = win_limit
	ScoreManager.win_limit = win_limit
	ScoreManager.gamemode_path = GameSettings.gamemode_scenes[GameSettings.gamemode_selected]
	
	get_tree().change_scene_to_file(GameSettings.gamemode_scenes[gamemode_selected]) # Replace with function body.
	queue_free()

func _on_quitbutton_pressed() -> void:
	get_tree().quit()

func change_player_count(amount):
	player_count += amount
	if player_count == 1:
		player_count = 8
	elif player_count == 9:
		player_count = 2
	player_count_button.text = str(player_count)
	
	var connected_joypads = Input.get_connected_joypads().size()
	if  connected_joypads < player_count:
		error_label.text = "Only %d controllers detected!" % (connected_joypads)
	else:
		error_label.text = ""
	
func change_win_limit_count(amount):
	win_limit += amount
	if win_limit == 0:
		win_limit = 30
	elif win_limit == 31:
		win_limit = 1
	win_limit_button.text = str(win_limit)

func _on_player_count_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		change_player_count(1)
		accept_event()
	if event.is_action_pressed("ui_left"):
		change_player_count(-1)
		accept_event()

func _on_win_limit_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		change_win_limit_count(1)
		accept_event()
	if event.is_action_pressed("ui_left"):
		change_win_limit_count(-1)
		accept_event()

func _on_tutorial_select_pressed() -> void:
	select_gamemode("tutorial")

func _on_bitematch_select_pressed() -> void:
	select_gamemode("bitematch")

func _on_elimination_select_pressed() -> void:
	select_gamemode("elimination")

func select_gamemode(mode: String):
	gamemode_selected = mode

	var selected_color = Color.CYAN
	var normal_color = Color.WHITE

	tutorial_select.modulate = selected_color if mode == "tutorial" else normal_color
	bitematch_select.modulate = selected_color if mode == "bitematch" else normal_color
	elimination_select.modulate = selected_color if mode == "elimination" else normal_color
