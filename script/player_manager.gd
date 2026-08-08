extends Node

@export var player_scene: PackedScene
@export var players_container: Node2D

signal players_spawned(players)

var min_pos = Vector2(100, 100)
var max_pos = Vector2(1152, 600)

func _ready():
	ScoreManager.player_eliminated.connect(_on_player_eliminated)
	pass

func spawn_players(spawn_points = []):
	var spawned := []
	
	var controllers = Input.get_connected_joypads()
	var count = min(GameSettings.player_count, controllers.size())

	for i in range(count):
		var player = player_scene.instantiate()
		player.player_id = controllers[i]

		# Spread players out initially

		if spawn_points and spawn_points.size() < players_container.get_children().size():
			player.position = spawn_points[i]
		else: # Randomize if no spawnpoints given or too few spawnpoints
			player.position = Vector2(
				randf_range(min_pos.x, max_pos.x),
				randf_range(min_pos.y, max_pos.y)
			)
		print("Spawned player ID: ", player.player_id)
		players_container.add_child(player)
		spawned.append(player)
	
	players_spawned.emit(spawned)
	return spawned

func get_players():
	return players_container.get_children()

func get_player(player_id: int):
	for player in players_container.get_children():
		if player.player_id == player_id:
			return player
	return null
	


func eliminate(player_id):
	var player = get_player(player_id)
	if player:
		player.eliminate()
	
func revive(player_id):
	var player = get_player(player_id)
	if player:
		player.revive()
	
func revive_players(spawn_points = []):
	for i in range(players_container.get_children().size()):
		if spawn_points:
			get_player(i).position = spawn_points[i]
		else:
			get_player(i).position = Vector2(
				randf_range(min_pos.x, max_pos.x),
				randf_range(min_pos.y, max_pos.y)
			)
		revive(i)

func _on_player_eliminated(player_id) -> void:
	eliminate(player_id)
