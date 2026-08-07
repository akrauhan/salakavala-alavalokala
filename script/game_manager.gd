extends Node


@export var player_manager: Node
@export var cooldown_ui : Control
@export var scoreboard: HBoxContainer
@export var winner_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreManager.scoreboard = scoreboard
	ScoreManager.winner_label = winner_label

	randomize()
	var players = player_manager.spawn_players()
	
	cooldown_ui.initialize(players)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
