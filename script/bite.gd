
extends Node2D
@export var sprite_2d: AnimatedSprite2D

@export var attack_distance := 40.0
@export var attack_duration := 0.4
@export var bite_cooldown := 2
@export var player_id := 0


@onready var bite_cooldown_timer := $BiteCooldown
@onready var bite_area := $BiteArea
@onready var attack_duration_timer: Timer = $BiteDuration
@onready var bite_sound: AudioStreamPlayer2D = $BiteSound

@export var bite_sounds: Array[AudioStream]
@onready var eyelight: PointLight2D = $Eyelight
@onready var bite_emitter: GPUParticles2D = $"../Sprite2D/BiteEmitter"

@export var normal_texture: Texture2D
@export var active_texture: Texture2D

@onready var bite_visualizer := $BiteVisualizer

signal bite_performed

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
	
	if direction.length() < 0.0:
		return false
	
	sprite_2d.play("bite")
	
	bite_visualizer.visible = true
	
	Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		0.5,		# Weak motor (0.0-1.0)
		0.5,		# Strong motor (0.0-1.0)
		0.2		# Duration in seconds
	)
	
	if player_id < bite_sounds.size():
		bite_sound.stream = bite_sounds[player_id]
	
	bite_sound.play()
	bite_emitter.emitting = true
	
	attack_duration_timer.start()	
	
	eyelight.energy=5
	
	
	bite_cooldown_timer.start()
	
	return true


func _on_bite_duration_timeout() -> void:
	bite_visualizer.visible = false
	
	bite_performed.emit(player_id)
	eyelight.energy=0
	for target in bite_area.get_overlapping_bodies():

		if target == get_parent():
			continue

		if target.has_method("take_damage"):
			target.take_damage(get_parent().player_id)
			Input.start_joy_vibration(
			player_id,	# Controller to vibrate
			1.0,		# Weak motor (0.0-1.0)
			0.5,		# Strong motor (0.0-1.0)
			0.5		# Duration in seconds
			)
			continue
