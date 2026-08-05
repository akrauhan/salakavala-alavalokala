extends Node

var scores := {}
var scoreboard: HBoxContainer
var winner_label: Label

@export var game_over_timer: Timer


var win_limit
var gamemode_path

func _ready() -> void:
	win_limit = GameSettings.win_limits[GameSettings.gamemode_selected]
	gamemode_path = GameSettings.gamemodes[GameSettings.gamemode_selected]

func add_player(player_id, start_score = 0):
	scores[player_id] = start_score
	
func add_score(player_id, amount):
	scores[player_id] += amount
	if scoreboard != null:
		scoreboard.update_scoreboard()
	else:
		push_error("Scoreboard reference missing.")
	if scores[player_id] >= win_limit:
		game_over(player_id)
	
func get_score(player_id):
	return scores.get(player_id, 0)

func game_over(player_id):
	print("Player ", player_id, " won")
	
	winner_label.text = "Player %d wins!" % (player_id + 1)

	winner_label.visible = true
	#label.position = Vector2(500,100)
	winner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	

	get_tree().create_timer(3).timeout.connect(func():
		get_tree().change_scene_to_file("res://menus/mainmenucontainer.tscn")
		scores.clear()
	)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
