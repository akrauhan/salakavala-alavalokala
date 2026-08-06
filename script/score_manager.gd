extends Node

var scores := {}
var winner_label: Label

@export var scoreboard: HBoxContainer
@export var game_over_timer: Timer

signal player_eliminated

var win_limit
var gamemode_path
var gamemode

func _ready() -> void:
	pass
	
func add_player(player_id, start_score = 0):
	if gamemode == "elimination":
		start_score = win_limit
	scores[player_id] = start_score
	scoreboard.update_scoreboard()
	
	
func add_score(player_id, amount):
	scores[player_id] += amount
	if scoreboard != null:
		scoreboard.update_scoreboard()
	else:
		push_error("Scoreboard reference missing.")
	if gamemode == "bitematch" and scores[player_id] >= win_limit:
		game_over(player_id)
	if gamemode == "elimination":
		if scores[player_id] == 0:
			eliminated(player_id)
		else:
			scores[player_id] =- 1
	
func get_score(player_id):
	return scores.get(player_id, 0)

func game_over(player_id):
	if gamemode == "bitematch":
		print("Player ", player_id, " won")
		
		winner_label.text = "Player %d wins!" % (player_id + 1)

		winner_label.visible = true
		#label.position = Vector2(500,100)
		winner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		

		get_tree().create_timer(3).timeout.connect(func():
			get_tree().change_scene_to_file("res://menus/mainmenucontainer.tscn")
			scores.clear()
		)
	

func eliminated(player_id):
	player_eliminated.emit(player_id)
	print("Player ", player_id, " eliminated!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
