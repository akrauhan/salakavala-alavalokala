extends Node2D

@onready var label: Label = $"UI/TutorialLabel"
@onready var playermanager = $PlayerManager

@export var decoy_scene: PackedScene
var decoy

var step := 0
var players := 0
var aim_progress := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players = playermanager.players_container.get_children().size()
	next_step()
	

func next_step():
	step += 1

	match step:
		1:
			show_message("Move with the left stick.")
		2:
			show_message("Aim your light with the right stick")
		3:
			show_message("Press LB to toggle light on or off.")
		4:
			show_message("Press LT to dash into the direction you are moving.")
		5:
			show_message("Press RT to bite towards your light.")
		6: 
			setup_final_step()
			show_message("Bite the decoy-fish in the middle to finish the tutorial.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match step:
		1:
			update_movement_progress()
	
		2:
			
			var input := Vector2(
				Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
				Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
			)

			if input.length() > 0.5:
				aim_progress += delta

			if aim_progress >= 2.0:
				next_step()
		3:
			update_light_progress()
		4:
			update_dash_progress()
		5:
			update_bite_progress()
	
	
func show_message(text):
	label.modulate.a = 0
	label.text = text

	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.3)
	

func update_movement_progress():
	var amount = players_moved()

	if amount >= 100*players: 
		next_step()

func players_moved():
	var total := 0
	
	for player in playermanager.players_container.get_children():
		total += player.global_position.distance_to(player.start_pos)
	
	return total


func update_light_progress():
	var pressed := false

	for player in playermanager.players_container.get_children():
		if Input.is_joy_button_pressed(player.player_id, JOY_BUTTON_LEFT_SHOULDER):
			pressed = true

	if pressed:
		next_step()

func update_dash_progress():
	
	var players_dashed = {}

	for player in playermanager.players_container.get_children():
		if Input.get_joy_axis(player.player_id,JOY_AXIS_TRIGGER_LEFT) >= 0.2:
			players_dashed[player.player_id] = true

	#progress.value = float(dashed_players.size()) / players * 100

	if players_dashed.size() >= players:
		next_step()
	
func update_bite_progress():
	var players_dashed = {}

	for player in playermanager.players_container.get_children():
		if Input.get_joy_axis(player.player_id,JOY_AXIS_TRIGGER_RIGHT) >= 0.2:
			players_dashed[player.player_id] = true

	#progress.value = float(dashed_players.size()) / players * 100

	if players_dashed.size() >= players:
		next_step()

func setup_final_step():
	decoy = decoy_scene.instantiate()

	decoy.position = Vector2(400, 400)
	decoy.required_players = players

	add_child(decoy)

	decoy.finished.connect(finish)

func finish():
	show_message("You did it!")
	
	get_tree().create_timer(3).timeout.connect(func():
		get_tree().change_scene_to_file("res://mainmenu.tscn")	
		queue_free()
	)
	
