extends Node

@export var player_scene: PackedScene
@export var players_container: Node2D

signal players_spawned(players)


func _ready():
	pass

func spawn_players():
	var spawned := []
	
	var controllers = Input.get_connected_joypads()
	var count = min(GameSettings.player_count, controllers.size())

	for i in range(count):
		var player = player_scene.instantiate()
		player.player_id = controllers[i]

		# Spread players out initially
		var min_pos = Vector2(100, 100)
		var max_pos = Vector2(1152, 600)

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

func eliminate(player_id):
	for player in players_container:
		if player.player_id == player_id:
			player.destroy()
			break
	
	


func _on_score_manager_player_eliminated(player_id) -> void:
	eliminate(player_id)
