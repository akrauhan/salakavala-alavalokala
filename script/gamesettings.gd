extends Node

var player_count := 2

var gamemode_selected := "default"

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

var gamemodes := {
	"default": "gamemodes/bitematch.tscn",
	"bitematch":"gamemodes/bitematch.tscn",
	"tutorial":"gamemodes/tutorial.tscn",
	"deathmatch":"gamemodes/deathmatch.tscn"
}

var win_limits := {
	"default": 1,
	"bitematch": 6,
	"tutorial": INT8_MAX,
	"deathmatch": 10
}
