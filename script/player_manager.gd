extends Node

@export var player_scene: PackedScene
@onready var players_container = $"../Players"
@onready var cooldown_ui = $"../UI/Cooldowns"

func _ready():
	spawn_players()

func spawn_players():
	var controllers = Input.get_connected_joypads()

	for i in controllers.size():
		var player = player_scene.instantiate()

		player.player_id = controllers[i]

		# Spread players out initially
		player.position = Vector2(i * 100+200, 0)

		players_container.add_child(player)
		cooldown_ui.add_player(player)
		
		print("Spawned player ID: ", player.player_id)
	
	
	cooldown_ui.players = players_container.get_children()	
	
