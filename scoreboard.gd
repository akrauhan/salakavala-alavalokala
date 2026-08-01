extends HBoxContainer

func _process(delta):
	update_scoreboard()

@export var SCREEN_WIDTH = 1000

var colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.PURPLE,
	Color.CYAN,
	Color.ORANGE,
	Color.HOT_PINK
]

func update_scoreboard():
	for child in get_children():
		child.queue_free()

	for player_id in ScoreManager.scores:
		var label := Label.new()
		label.text = "P%d: %d" % [
			player_id + 1,
			ScoreManager.get_score(player_id)
		]

		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		label.add_theme_color_override(
			"font_color",
			colors[player_id]
		)

		add_child(label)
