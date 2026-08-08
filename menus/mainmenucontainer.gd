extends Node
@onready var flapper := $"Kala/FlapperAnimation"
@onready var flapper2 := $"Kala2/FlapperAnimation"

@onready var main_menu: Control = $MainMenu
@onready var options_menu: Control = $OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flapper.play()
	flapper2.play()
	
	main_menu.options_requested.connect(_show_options_menu)
	options_menu.back_requested.connect(_show_main_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _show_options_menu() -> void:
	main_menu.visible = false
	options_menu.visible = true
	options_menu.grab_default_focus()
 
func _show_main_menu() -> void:
	options_menu.visible = false
	main_menu.visible = true
	main_menu.grab_default_focus()
