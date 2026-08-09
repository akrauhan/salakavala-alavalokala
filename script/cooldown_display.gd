extends Control

var container: HBoxContainer

var circles: Array[TextureProgressBar] = []
var players: Array = []



func initialize(player_list):
	container = $CooldownContainer
	players = player_list
	create_cooldowns()
		
func create_cooldowns():
	for circle in circles:
		circle.queue_free()
	circles.clear()

	for i in range(players.size()):
		var circle := TextureProgressBar.new()
		
		circle.name = "Player%dBiteCooldown" % i
		circle.fill_mode = TextureProgressBar.FILL_CLOCKWISE
		circle.max_value = 100
		circle.value = 100
		circle.texture_progress = preload("res://asset/gfx/progress.png")
		circle.tint_progress = GameSettings.colors[i]
		
		container.add_child(circle)
		circles.append(circle)


func _process(delta):
	for i in players.size():
		circles[i].value = players[i].ability_charge * 100.0
