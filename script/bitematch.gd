extends Gamemode

@onready var game_start_sequence = $GameStartSequence

## Bitematch rules: every successful bite scores the attacker a point;
## first to the configured win limit wins. Unlimited health (default).

func on_players_ready() -> void:
	for player in players:
		player.took_damage.connect(_on_player_took_damage)
		player.start_game_intro()
		
	game_start_sequence.start_sequence_finished.connect(_on_game_start_finished)	
	
	game_start_sequence.start(players)

func _on_game_start_finished() -> void:
	for player in players:
		player.finish_game_intro()

func _on_player_took_damage(attacker_id, _victim_id) -> void:
	ScoreManager.add_score(attacker_id, 1)

	var win_limit: int = GameSettings.win_limits[GameSettings.gamemode_selected]
	if ScoreManager.get_score(attacker_id) >= win_limit:
		trigger_game_over(attacker_id)
