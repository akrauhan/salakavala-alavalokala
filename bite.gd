extends Area2D

@export var attack_distance := 40.0
@export var attack_duration := 0.15
@export var bite_cooldown := 0.5
@export var player_id := 0


@onready var bite_timer := $BiteCooldown
@onready var bite_sprite := $BiteVisualizer

@export var normal_texture: Texture2D
@export var active_texture: Texture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bite_timer.wait_time = bite_cooldown
	bite_sprite.texture = normal_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass


func melee(player_id, direction):
	if direction.length() < 0.4 or !bite_timer.is_stopped(): #TODO: Make deadzone global
		return
	
	attack(direction)

var attacking := false

func attack (direction: Vector2):	
	if attacking: 
		return
	attacking = true
	var locked_direction = direction.normalized()
	
	bite_sprite.texture = active_texture
	
	position = locked_direction * attack_distance
	rotation = locked_direction.angle()
	
	
	for target in get_overlapping_bodies():
		if target == get_parent():
			continue

		if target.has_method("take_damage"):
			target.take_damage()
	
	await get_tree().create_timer(attack_duration).timeout
	
	bite_sprite.texture = normal_texture
	attacking = false
	
	bite_timer.start()
