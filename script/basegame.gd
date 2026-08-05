extends Node2D
@onready var basegame = $Basegame
@onready var gamemode_label = $BaseUI/GamemodeLabel

signal players_ready(players)
@onready var player_manager = $GameManager/PlayerManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreManager.scoreboard = $UI/MarginContainer/Scoreboard
	gamemode_label.text = GameSettings.gamemode_selected
	player_manager.players_spawned.connect(_on_players_spawned)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_players_spawned(players):
	players_ready.emit(players)
