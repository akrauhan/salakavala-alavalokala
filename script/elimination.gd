extends Gamemode

## CLAUDE
## Elimination rules: players use up their health (1 = one-hit-kill, from
## GameSettings.player_healths) and are removed from play when it runs out.
## Last player alive wins.

@export var round_restart_delay := 3.0

var win_limit: int
var alive_players: Array = []

func get_start_health(_player_id) -> int:
	return 1 # Every bite eliminates

func on_players_ready() -> void:
	win_limit = GameSettings.win_limits[GameSettings.gamemode_selected]	
	for player in players:
		player.took_damage.connect(_on_player_took_damage)
	start_round()

func start_round():
	alive_players = players.duplicate()
	for player in players:
		player.revive()
		player.player_health = get_start_health(player.player_id)

func _on_player_took_damage(attacker_id, victim_id):
	ScoreManager.add_score(attacker_id, 1)
	ScoreManager.eliminate_player(victim_id)
	alive_players = alive_players.filter(func(p): return p.player_id != victim_id)
	
	if ScoreManager.get_score(attacker_id) >= win_limit:
		trigger_game_over(attacker_id)
	
	if alive_players.size() == 1:
		get_tree().create_timer(round_restart_delay).timeout.connect(start_round)
