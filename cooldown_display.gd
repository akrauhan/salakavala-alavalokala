extends Control

@export var players: Array[Node]

@onready var circles = [
	$VBoxContainer/Player0BiteCooldown,
	$VBoxContainer/Player1BiteCooldown,
	$VBoxContainer/Player2BiteCooldown,
	$VBoxContainer/Player3BiteCooldown,
	$VBoxContainer/Player4BiteCooldown,
	$VBoxContainer/Player5BiteCooldown,
	$VBoxContainer/Player6BiteCooldown,
	$VBoxContainer/Player7BiteCooldown
]

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

func _ready():
	for i in players.size():
		circles[i].tint_progress = colors[i]
	
func _process(delta):
	for i in players.size():
		var player = players[i]
		var timer = player.get_node("Bite/BiteCooldown")

		var progress = 1.0 - (timer.time_left / timer.wait_time)
		circles[i].value = progress * 100

		
		
