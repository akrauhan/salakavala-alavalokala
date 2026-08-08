extends Node
@onready var flapper := $"Kala/FlapperAnimation"
@onready var flapper2 := $"Kala2/FlapperAnimation"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flapper.play()
	flapper2.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
