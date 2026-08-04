extends Node

@export var player_scene: PackedScene
@onready var players_container = $"../World/Players"
@onready var cooldown_ui = $"../UI/Cooldowns"

func _ready():
	randomize()
	spawn_players()

func spawn_players():
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

		players_container.add_child(player)
		cooldown_ui.add_player(player)
		
		print("Spawned player ID: ", player.player_id)
	
	
	cooldown_ui.players = players_container.get_children()	
	
