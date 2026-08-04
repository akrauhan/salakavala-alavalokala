extends Control

@onready var player_count_button := $VBoxContainer/PlayerCount/PlayerCountButton
@onready var win_limit_button := $VBoxContainer/WinLimit/WinLimitButton
@onready var flapper := $Kala/FlapperAnimation
@onready var flapper2 := $Kala2/FlapperAnimation
@onready var start_button := $VBoxContainer/StartButton

@onready var tutorial_select = $VBoxContainer/HBoxContainer/TutorialSelect
@onready var bitematch_select = $VBoxContainer/HBoxContainer/BitematchSelect
@onready var deathmatch_select = $VBoxContainer/HBoxContainer/DeathmatchSelect

var win_limit 
var player_count
var gamemode_scenes = GameSettings.gamemodes
var gamemode_selected_scene = gamemode_scenes["default"]
var gamemode_selected = "default"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusic.play()
	flapper.play()
	flapper2.play()
	start_button.grab_focus()
	
	player_count = GameSettings.player_count
	win_limit = GameSettings.win_limits["default"]


func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("ui_accept")

func _on_start_button_pressed() -> void:
	GameSettings.player_count = player_count
	GameSettings.win_limits["default"] = win_limit
	get_tree().change_scene_to_file(gamemode_selected_scene) # Replace with function body.
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

func _on_deathmatch_select_pressed() -> void:
	select_gamemode("deathmatch")

func select_gamemode(mode: String):
	gamemode_selected = mode


	var selected_color = Color.CYAN
	var normal_color = Color.WHITE

	tutorial_select.modulate = selected_color if mode == "tutorial" else normal_color
	bitematch_select.modulate = selected_color if mode == "bitematch" else normal_color
	deathmatch_select.modulate = selected_color if mode == "deathmatch" else normal_color
