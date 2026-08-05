extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func shake(duration := 0.5, strength := 4.0):
	var original_pos = position
	var end_time = Time.get_ticks_msec() + int(duration * 1000)
	print("shook")
	while Time.get_ticks_msec() < end_time:
		position = original_pos + Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		await get_tree().create_timer(0.03).timeout

	position = original_pos
