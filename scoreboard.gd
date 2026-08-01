extends VBoxContainer

func _process(delta):
	update_scoreboard()


func update_scoreboard():
	for child in get_children():
		child.queue_free()

	for player_id in ScoreManager.scores:
		var label = Label.new()
		label.text = "Player %s: %s" % [
			player_id+1,
			ScoreManager.get_score(player_id)
		]
		add_child(label)
