extends Node2D

signal start_sequence_finished

@export var entrance_duration := 1.0
@export var start_text_duration := 1.0

@onready var start_label: Label = $StartLabel
@onready var start_sound: AudioStreamPlayer = $StartAudio

var players: Array = []
var finished_players := 0

func start(player_list: Array) -> void:
	players = player_list
	finished_players = 0
	start_label.visible = false
	for player in players:
		start_player_entrance(player)

func start_player_entrance(player) -> void:
	# Save the actual gameplay position.
	var target_position = player.global_position

	# Put the player outside the screen.
	var viewport_size := get_viewport_rect().size
	var direction = (target_position - viewport_size / 2.0).normalized()

	if direction == Vector2.ZERO:
		direction = Vector2.UP

	var start_position = target_position + direction * 500.0

	player.global_position = start_position

	# Disable normal player control/physics here later.
	player.freeze = true

	# Player-colored light.
	player.orbiting_sphere.get_node("PointLight2D").color = GameSettings.colors[player.player_id]

	var tween := create_tween()
	tween.tween_property(
		player,
		"global_position",
		target_position,
		entrance_duration
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_callback(_player_arrived)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _player_arrived() -> void:
	finished_players += 1

	if finished_players >= players.size():
		show_start_text()


func show_start_text() -> void:
	start_label.visible = true
	start_sound.play()

	await get_tree().create_timer(start_text_duration).timeout

	start_sequence_finished.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
