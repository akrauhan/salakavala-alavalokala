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

# CLAUDE
# --- Display settings ---
# The three most common windowed resolutions. Index into this from the
# options menu; DisplayServer calls only happen in apply_display_settings().
var resolution_options := [
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
]
var resolution_index := 1 # default: 1920x1080
var fullscreen := false
 
func _ready() -> void:
	apply_display_settings()
 
## Single place that actually talks to the OS window. Called on boot (so the
## last chosen resolution/fullscreen state is active from the start) and
## again by the options menu whenever the player changes a setting.
func apply_display_settings() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(resolution_options[resolution_index])
		_center_window()
 
func _center_window() -> void:
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_position((screen_size - window_size) / 2)
