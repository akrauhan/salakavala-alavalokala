extends Control

@onready var player_count_button := $VBoxContainer/PlayerCount/PlayerCountButton
@onready var win_limit_button := $VBoxContainer/WinLimit/WinLimitButton
@onready var flapper := $Kala/FlapperAnimation
@onready var flapper2 := $Kala2/FlapperAnimation
@onready var start_button := $VBoxContainer/StartButton

var win_limit 
var player_count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusic.play()
	flapper.play()
	flapper2.play()
	start_button.grab_focus()
	
	player_count = GameSettings.player_count
	win_limit = GameSettings.win_limit


func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("ui_accept")

func _on_start_button_pressed() -> void:
	GameSettings.player_count = player_count
	GameSettings.win_limit = win_limit
	get_tree().change_scene_to_file("res://gamemodes/versus.tscn") # Replace with function body.
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
	
