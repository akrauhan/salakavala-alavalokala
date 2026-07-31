extends Node

var scores := {}

func add_player(player_id):
	scores[player_id] = 0
	
func add_score(player_id, amount):
	scores[player_id] += amount
	
func get_score(player_id):
	return scores.get(player_id, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
