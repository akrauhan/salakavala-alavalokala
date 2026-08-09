extends Node

@export var player_scene: PackedScene
@export var players_container: Node2D

signal players_spawned(players)

@export var border_left: StaticBody2D
@export var border_right: StaticBody2D
@export var border_top: StaticBody2D
@export var border_bottom: StaticBody2D

var min_pos = Vector2(100, 100)
var max_pos = Vector2(1152, 600)

var d = 200

var min_distance = 300 # between players when spawning
var max_spawn_attempts := 100

func _ready():
	min_pos = Vector2(border_left.position.x + d, border_top.position.y + d)
	max_pos = Vector2(border_right.position.x - d, border_bottom.position.y - d)
	print(min_pos)
	print(max_pos)
	
	ScoreManager.player_eliminated.connect(_on_player_eliminated)
	pass

func spawn_players(spawn_points = []):
	var spawned := []

	var controllers = Input.get_connected_joypads()
	var count = min(GameSettings.player_count, controllers.size())

	for i in range(count):
		var player = player_scene.instantiate()
		player.player_id = controllers[i]

		var spawn_position: Vector2

		# Use predefined spawn point if available.
		if i < spawn_points.size():
			spawn_position = spawn_points[i]
		else:
			spawn_position = find_spawn_position(spawned)

		player.position = spawn_position

		players_container.add_child(player)
		spawned.append(player)

		print("Spawned player ID: ", player.player_id, " at ", player.position)

	players_spawned.emit(spawned)
	return spawned


func find_spawn_position(existing_players: Array) -> Vector2:
	for attempt in range(max_spawn_attempts):
		var candidate := Vector2(
			randf_range(min_pos.x, max_pos.x),
			randf_range(min_pos.y, max_pos.y)
		)

		var valid := true

		for player in existing_players:
			if candidate.distance_to(player.position) < min_distance:
				valid = false
				break

		if valid:
			return candidate

	# If no valid position was found after 100 attempts,
	# return a random position rather than getting stuck forever.
	push_warning("Could not find spawn position at required distance.")
	return Vector2(
		randf_range(min_pos.x, max_pos.x),
		randf_range(min_pos.y, max_pos.y)
	)

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
