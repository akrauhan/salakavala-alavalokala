extends HBoxContainer

signal value_changed(value)

@export var minimum := 2
@export var maximum := 8
@export var value := 2

@onready var value_label := $ValueLabel


func _ready():
	update_label()


func _gui_input(event):
	if event.is_action_pressed("ui_left"):
		value = max(value - 1, minimum)
		update_label()
		value_changed.emit(value)
		accept_event()

	elif event.is_action_pressed("ui_right"):
		value = min(value + 1, maximum)
		update_label()
		value_changed.emit(value)
		accept_event()


func update_label():
	value_label.text = str(value)
	
func _on_focus_entered():
	pass 
	
func _on_focus_exited():
	pass
	
