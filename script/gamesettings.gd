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
		_set_windowed_size_and_position(resolution_options[resolution_index])
 
func _set_windowed_size_and_position(window_size: Vector2i) -> void:
	# Always target the primary screen explicitly, rather than "whichever
	# screen the window currently overlaps" -- on multi-monitor setups
	# (especially with a rotated second monitor), that detection can flip
	# mid-resize and land the window in the gap between monitors.
	var screen := DisplayServer.get_primary_screen()
	var screen_position = DisplayServer.screen_get_position(screen)
	var screen_size = DisplayServer.screen_get_size(screen)
	var target_position = screen_position + (screen_size - window_size) / 2
 
	DisplayServer.window_set_position(target_position)
	DisplayServer.window_set_size(window_size)
