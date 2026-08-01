
extends Node2D
@export var sprite_2d: AnimatedSprite2D

@export var attack_distance := 40.0
@export var attack_duration := 0.4
@export var bite_cooldown := 0.8
@export var player_id := 0


@onready var bite_cooldown_timer := $BiteCooldown
@onready var bite_area := $BiteArea
@onready var attack_duration_timer: Timer = $BiteDuration
@onready var bite_sound: AudioStreamPlayer2D = $BiteSound

@export var bite_sounds: Array[AudioStream]

@export var bite_sfx: AudioStreamPlayer
@export var normal_texture: Texture2D
@export var active_texture: Texture2D


# Called when the node enters the scene tree for the first time.
func _ready():
	bite_cooldown_timer.wait_time = bite_cooldown
	attack_duration_timer.wait_time = attack_duration
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

var attacking := false

func attack(direction) -> bool: # Returns if attack was successful		
	if !attack_duration_timer.is_stopped() or !bite_cooldown_timer.is_stopped() or attacking: 
		return false
	
	if direction.length() < 0.4:
		return false
	
	sprite_2d.play("bite")
	
	if player_id < bite_sounds.size():
		bite_sound.stream = bite_sounds[player_id]
	
	bite_sound.play()
	
	var locked_direction = direction.normalized()
	
	position = locked_direction * attack_distance
	rotation = locked_direction.angle()
	
	attack_duration_timer.start()	
	bite_cooldown_timer.start()
	
	return true


func _on_bite_duration_timeout() -> void:
	print("Bite timeout")
	
	for target in bite_area.get_overlapping_bodies():

		if target == get_parent():
			continue

		if target.has_method("take_damage"):
			target.take_damage(get_parent().player_id)
	
