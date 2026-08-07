extends Node

var scores := {}
var winner_label: Label

@export var scoreboard: HBoxContainer
@export var game_over_timer: Timer

signal player_eliminated

# Not needed anymore, kept so mainmenu.gd does not need changes
var win_limit
var gamemode_path
var gamemode

func _ready() -> void:
	pass
	
func add_player(player_id, start_score = 0):
	scores[player_id] = start_score
	if scoreboard:
		scoreboard.update_scoreboard()
	
	
func add_score(player_id, amount):
	scores[player_id] = scores.get(player_id, 0) + amount
	if scoreboard != null:
		scoreboard.update_scoreboard()
	else:
		push_error("Scoreboard reference missing.")
	
func get_score(player_id):
	return scores.get(player_id, 0)

func show_winner(winner_id: int, message := "") -> void:
	if winner_label == null:
		push_error("winner_label reference missing")
		return
	
	print("Player ", winner_id, " won")
	winner_label.text = message if message != "" else "Player %d wins!" % (winner_id + 1)
	winner_label.visible = true
	winner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	get_tree().create_timer(3).timeout.connect(func():
		get_tree().change_scene_to_file("res://menus/mainmenucontainer.tscn")
		scores.clear()
	)


func eliminate_player(player_id):
	player_eliminated.emit(player_id)
	print("Player ", player_id, " eliminated!")
