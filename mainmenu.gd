extends Control

@onready var player_count := $VBoxContainer/PlayerCount
@onready var win_limit := $VBoxContainer/WinLimit
@onready var flapper := $Kala/FlapperAnimation
@onready var flapper2 := $Kala2/FlapperAnimation
@onready var start_button := $VBoxContainer/StartButton

var active_spinbox: SpinBox = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusic.play()
	flapper.play()
	flapper2.play()
	start_button.grab_focus()


func _process(delta):
	if active_spinbox == null:
		return

	if Input.is_action_just_pressed("ui_left"):
		active_spinbox.value -= active_spinbox.step

	elif Input.is_action_just_pressed("ui_right"):
		active_spinbox.value += active_spinbox.step
		

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("ui_accept")

func _on_start_button_pressed() -> void:
	GameSettings.player_count = player_count.value
	GameSettings.win_limit = win_limit.value
	get_tree().change_scene_to_file("res://gamemodes/versus.tscn") # Replace with function body.
	queue_free()


func _on_quitbutton_pressed() -> void:
	get_tree().quit()



func _on_player_count_spin_box_focus_entered() -> void:
	active_spinbox = player_count

func _on_player_count_spin_box_focus_exited() -> void:
	if active_spinbox == player_count:
		active_spinbox = null
