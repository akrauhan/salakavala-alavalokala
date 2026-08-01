extends Control

@onready var player_count := $VBoxContainer/HBoxContainer/SpinBox
@onready var win_limit := $VBoxContainer/HBoxContainer2/SpinBox
@onready var flapper := $Kala/FlapperAnimation
@onready var flapper2 := $Kala2/FlapperAnimation
@onready var start_button := $VBoxContainer/StartButton
@onready var spin_box: SpinBox = $VBoxContainer/HBoxContainer/SpinBox
@onready var spin_box2: SpinBox = $VBoxContainer/HBoxContainer2/SpinBox
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	start_button.pressed.connect(func():
		print("Button pressed")
	)
	flapper.play()
	flapper2.play()
	start_button.grab_focus()
	spin_box.value = min(Input.get_connected_joypads().size(), 2)
	spin_box2.value = GameSettings.win_limit
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("ui_accept")

func _on_start_button_pressed() -> void:
	GameSettings.player_count = int(player_count.value)
	GameSettings.win_limit = int(win_limit.value)
	get_tree().change_scene_to_file("res://main.tscn") # Replace with function body.
	queue_free()


func _on_quitbutton_pressed() -> void:
	get_tree().quit()
	
