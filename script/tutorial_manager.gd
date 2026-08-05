extends Node2D

@onready var label: Label = $"UI/TutorialLabel"
@onready var playermanager = $Basegame/PlayerManager
@onready var progress_bar = $UI/ProgressBar
@onready var basegame = $Basegame

@export var decoy_scene: PackedScene

var decoy

var step := 0
var players := 0
var aim_progress := {}
var light_toggles := {}
var dashed_players := {}
var bitten_players := {}
var final_bites := {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	basegame.players_ready.connect(setup_tutorial)

func setup_tutorial(player_list):
	players = player_list.size()

	for player in player_list:
		aim_progress[player.player_id] = 0.0
		light_toggles[player.player_id] = 0
		dashed_players[player.player_id] = false
		bitten_players[player.player_id] = false

		player.get_node("Bite").bite_performed.connect(_on_bite_performed)

	next_step()
	
func next_step():
	step += 1

	match step:
		1:
			progress_bar.value = 0
			show_message("Move with the left stick.")
		2:
			progress_bar.value = 0
			show_message("Aim your light with the right stick")
		3:
			progress_bar.value = 0
			show_message("Press LB to toggle light on or off.")
		4:
			progress_bar.value = 0
			show_message("Press LT to dash into the direction you are moving.")
		5:
			progress_bar.value = 0
			show_message("Press RT to bite towards your light.")
		6: 
			progress_bar.value = 0
			setup_final_step()
			show_message("Bite the decoy-fish in the middle to finish the tutorial.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match step:
		1:
			update_movement_progress()
		2:
			update_aim_progress(delta)
		3:
			update_light_progress()
		4:
			update_dash_progress()
		5:
			update_bite_progress()
		6:
			update_final_progress()
	
	
func show_message(text):
	label.modulate.a = 0
	label.text = text

	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.3)

func update_movement_progress():
	var step_goal := 200.0
	var movements := players_moved()

	var completed := 0
	
	var sum = 0
	for player_id in movements:
		var progress = min(movements[player_id], step_goal)
		sum += progress
		if movements[player_id] >= step_goal:
			completed += 1

	progress_bar.value = sum / (players * step_goal)

	if completed >= players:
		next_step()


func players_moved() -> Dictionary:
	var player_progress = {}
	for player in playermanager.players_container.get_children():
		player_progress[player.player_id] = player.global_position.distance_to(player.start_pos)
	return player_progress


func update_light_progress():
	var required_toggles := 1
	var completed := 0
	var total_progress := 0.0

	for player in playermanager.players_container.get_children():
		var pressed := Input.is_joy_button_pressed(
			player.player_id,
			JOY_BUTTON_LEFT_SHOULDER
		)

		# Detect button press, not button hold
		if pressed:
			light_toggles[player.player_id] += 1

		
		var player_progress = min(light_toggles[player.player_id], required_toggles)
		total_progress += player_progress

		if light_toggles[player.player_id] >= required_toggles:
			completed += 1

	progress_bar.value = total_progress / (players * required_toggles)

	if completed >= players:
		next_step()


func update_dash_progress():
	var completed := 0
	var total_progress := 0.0

	for player in playermanager.players_container.get_children():
		var trigger_pressed := Input.get_joy_axis(
			player.player_id,
			JOY_AXIS_TRIGGER_LEFT
		) >= 0.2 
		var not_deadzoned := Vector2(Input.get_joy_axis(player.player_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player.player_id, JOY_AXIS_LEFT_Y)).length() >= 0.4

		if trigger_pressed and not_deadzoned:
			dashed_players[player.player_id] = true

		if dashed_players[player.player_id]:
			total_progress += 1
			completed += 1

	progress_bar.value = total_progress / players

	if completed >= players:
		next_step()
	
func update_aim_progress(delta):
	var aim_goal := 1.0

	var completed := 0
	var sum := 0.0

	for player in playermanager.players_container.get_children():
		var input := Vector2(
			Input.get_joy_axis(player.player_id, JOY_AXIS_RIGHT_X),
			Input.get_joy_axis(player.player_id, JOY_AXIS_RIGHT_Y)
		)

		if input.length() > 0.5:
			aim_progress[player.player_id] += delta

		var progress = min(aim_progress[player.player_id], aim_goal)
		sum += progress

		if aim_progress[player.player_id] >= aim_goal:
			completed += 1

	progress_bar.value = sum / (players * aim_goal)

	if completed >= players:
		next_step()
	

func update_bite_progress():
	var completed := 0
	var total_progress := 0.0

	for player_id in bitten_players:
		if bitten_players[player_id]:
			total_progress += 1
			completed += 1

	progress_bar.value = total_progress / players

	if completed >= players:
		next_step()

func _on_bite_performed(player_id):
	bitten_players[player_id] = true

func setup_final_step():
	decoy = decoy_scene.instantiate()

	decoy.position = Vector2(400, 400)
	decoy.required_players = players
	decoy.finished.connect(finish)
	
	add_child(decoy)



func update_final_progress():
	if decoy == null:
		return
	
	progress_bar.value = float(decoy.players_bitten.size()) / players

func finish():
	show_message("You did it!")
	
	get_tree().create_timer(3).timeout.connect(func():
		get_tree().change_scene_to_file("res://menus/mainmenucontainer.tscn")	
		queue_free()
	)
	
