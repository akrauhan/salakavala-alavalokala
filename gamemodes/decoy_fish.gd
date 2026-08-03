extends RigidBody2D

signal finished

var players_bitten := {}

@export var required_players := 2

func take_damage(attacker_id):
	if players_bitten.has(attacker_id):
		return

	players_bitten[attacker_id] = true
	print("Player ", attacker_id, " bit decoy")

	if players_bitten.size() >= required_players:
		finished.emit()
