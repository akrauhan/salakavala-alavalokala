extends Control

@onready var player_count := $VBoxContainer/HBoxContainer/SpinBox
@onready var flapper := $Kala/FlapperAnimation
@onready var flapper2 := $Kala2/FlapperAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flapper.play()
	flapper2.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	GameSettings.player_count = int(player_count.value)
	get_tree().change_scene_to_file("res://main.tscn") # Replace with function body.


func _on_quitbutton_pressed() -> void:
	get_tree().quit()
