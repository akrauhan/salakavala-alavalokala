extends Node

var player_count := 2

var gamemode_selected = "bitematch" # Default gamemode selected at game launch

var colors := [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.PURPLE,
	Color.CYAN,
	Color.ORANGE,
	Color.HOT_PINK
]

var gamemode_scenes := {
	"default": "res://gamemodes/bitematch.tscn",
	"bitematch":"res://gamemodes/bitematch.tscn",
	"tutorial":"res://gamemodes/tutorial.tscn",
	"elimination":"res://gamemodes/elimination.tscn"
}

var win_limits := {
	"default": 1,
	"bitematch": 6,
	"tutorial": INT8_MAX,
	"elimination": 10
}

var player_healths := { # -1 for unlimited health
	"default": -1,
	"bitematch": -1,
	"tutorial": -1,
	"elimination": 1
}
