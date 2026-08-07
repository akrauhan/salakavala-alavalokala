extends Gamemode

## CLAUDE
## Elimination rules: players use up their health (1 = one-hit-kill, from
## GameSettings.player_healths) and are removed from play when it runs out.
## Last player alive wins.

var alive_count := 0

func get_start_health(_player_id) -> int:
	return GameSettings.player_healths[GameSettings.gamemode_selected]

func on_players_ready() -> void:
	alive_count = players.size()
	for player in players:
		player.health_depleted.connect(_on_player_health_depleted)

func _on_player_health_depleted(player_id) -> void:
	ScoreManager.eliminate_player(player_id)
	alive_count -= 1

	if alive_count == 1:
		for player in players:
			if player.player_health > 0:
				trigger_game_over(player.player_id)
				break
