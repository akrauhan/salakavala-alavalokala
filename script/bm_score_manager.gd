extends Node

# Scoremanager for Bitematch-gamemode (no-one dies, successful bites give score)

var scores := {}

@export var game_over_timer: Timer

var scoreboard

func add_player(player_id):
	scores[player_id] = 0
	
func add_score(player_id, amount):
	scores[player_id] += amount
	scoreboard.update_scoreboard()
	if scores[player_id] >= GameSettings.win_limit:
		game_over(player_id)
	
func get_score(player_id):
	return scores.get(player_id, 0)

func game_over(player_id):
	print("Player ", player_id, " won")
	
	var label = get_tree().current_scene.get_node("UI/WinnerLabel")

	label.text = "Player %d wins!" % (player_id + 1)

	label.visible = true
	#label.position = Vector2(500,100)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	var colors = [
		Color.RED,
		Color.BLUE,
		Color.GREEN,
		Color.YELLOW,
		Color.PURPLE,
		Color.CYAN,
		Color.ORANGE,
		Color.HOT_PINK
	]
	
	label.add_theme_color_override("font_color", colors[player_id])

	
	
	
	get_tree().create_timer(3).timeout.connect(func():
		get_tree().change_scene_to_file("res://mainmenu.tscn")
		scores.clear()
	)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
