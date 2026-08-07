extends Gamemode

## CLAUDE
## Bitematch rules: every successful bite scores the attacker a point;
## first to the configured win limit wins. Unlimited health (default).

func on_players_ready() -> void:
	for player in players:
		player.took_damage.connect(_on_player_took_damage)

func _on_player_took_damage(attacker_id, _victim_id) -> void:
	ScoreManager.add_score(attacker_id, 1)

	var win_limit: int = GameSettings.win_limits[GameSettings.gamemode_selected]
	if ScoreManager.get_score(attacker_id) >= win_limit:
		trigger_game_over(attacker_id)
