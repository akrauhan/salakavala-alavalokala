extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for id in Input.get_connected_joypads():
		print(Input.get_joy_name(id))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
