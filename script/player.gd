extends RigidBody2D
@onready var flapper_animation: AnimatedSprite2D = $Sprite2D/FlapperAnimation
@onready var blood_animation: AnimatedSprite2D = $BloodAnimation
@onready var flapper_emitter: GPUParticles2D = $Sprite2D/FlapperEmitter
@onready var parry_light: PointLight2D = $Parry/ParryLight
@onready var parry_collision: PointLight2D = $Parry/ParryCollision
@onready var parry_sparks: GPUParticles2D = $Parry/ParrySparks
@onready var dash_emitter: GPUParticles2D = $Sprite2D/DashEmitter
@onready var dodge_emitter: GPUParticles2D = $Sprite2D/DodgeEmitter


@export var player_id := 0
@export var deadzone := 0.4

@export var dash_strength := 600
@export var dash_cooldown := 2
@export var stun_time := 1 # Time spent stunned after hit
@export var stun_speed := 1 # Speed of movement when stunned
@export var flap_strength := 100
@export var flap_cooldown := 0.25
@export var biteimpulse_strength := 600

@onready var dash_timer: Timer = $DashCooldown
@onready var bite_timer: Timer = $Bite/BiteCooldown
@onready var flap_timer: Timer = $FlapCooldown
@onready var stun_timer: Timer = $StunTimer
@onready var parry_timer: Timer = $Parry/ParryTimer
@onready var dodge_timer: Timer = $Parry/DodgeTimer


@onready var orbiting_sphere = $OrbitingSphere
@onready var melee_attack = $Bite
@onready var parry_area = $Parry/ParryExplosionArea
@onready var dodge_area: Area2D = $Parry/DodgeArea

@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var parry_sound: AudioStreamPlayer2D = $Parry/ParrySound

@export var hurt_sounds: Array[AudioStream]


var start_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dash_timer.wait_time = dash_cooldown
	flap_timer.wait_time = flap_cooldown
	stun_timer.wait_time = stun_time
	orbiting_sphere.player_id = player_id
	melee_attack.player_id = player_id
	start_pos = global_position
	ScoreManager.add_player(player_id)


var toggle_light_previous := false


	
	
@export var thrust := 500.0
#	var input = Vector2(
#		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X),
#		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)


func _physics_process(delta):
	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)
	)
	
	if input.length() < deadzone and stun_timer.is_stopped():
		input = Vector2.ZERO
		flapper_animation.play("loop")
		
	flap(input)


	# DASH_INPUT
	if Input.get_joy_axis(player_id,JOY_AXIS_TRIGGER_LEFT) >= 0.5:
		dash()
	
	
	var input2 = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_Y)
	)
	
	rotation = input2.angle()
	

	var attack_pressed = Input.get_joy_axis(player_id,JOY_AXIS_TRIGGER_RIGHT) >= 0.2

	
	if attack_pressed and !attack_previous:
		var direction = input2
		
		if melee_attack.attack(direction):
			#var stop_time = 0.25
			#var easing_curve = 3
			#ease(min(delta/stop_time, 1), easing_curve)
			#input2.enabled = 1
			 #Pakottaa liikkeen pysähtymisen, lukitsee sitten input-suunnan ja laukaisee suuntaan.
			apply_impulse(direction.normalized()*biteimpulse_strength)
			#await bite_timer
			#odottaa puraisun valmistumisen
			#input2.enabled = 1
			#Vapauttaa puraisun valmistuttua katseen pyörittämisen



func flap(direction):
	if direction == Vector2.ZERO:
		flapper_emitter.emitting = false
		return
	flapper_emitter.emitting = true
	if !flap_timer.is_stopped():
		return
	
	apply_impulse(direction.normalized() * flap_strength)
	Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		0.05,		# Weak motor (0.0-1.0)
		0,		# Strong motor (0.0-1.0)
		0.125		# Duration in seconds
	)
	flap_timer.start()

var attack_previous := false


func take_damage(attacker_id):
	if get_tree().current_scene.name == "Tutorial": # No damage in tutorial
		return
	if !bite_timer.is_stopped(): # Parry
				
		parry_area.global_position = global_position
		
		Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		0,		# Weak motor (0.0-1.0)
		1.0,		# Strong motor (0.0-1.0)
		0.5		# Duration in seconds
		)
		parry_sound.play()
		parry_timer.start()
		parry_light.energy = 10
		parry_collision.energy = 16
		parry_sparks.emitting = true
		
		return
	if !dodge_timer.is_stopped() and false: # Dodge
		
		dodge_area.global_position = global_position
		
		Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		1.0,		# Weak motor (0.0-1.0)
		0.0,		# Strong motor (0.0-1.0)
		0.2		# Duration in seconds
		)
		#dodge_sound.play()
		dodge_emitter.emitting = true
		
		return
	
	
	print("Player ", player_id, "hit")
	if player_id < hurt_sounds.size():
		hurt_sound.stream = hurt_sounds[player_id]
	hurt_sound.play()
	blood_animation.play("blood")  
		
	ScoreManager.add_score(attacker_id, 1)
	
	Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		1.0,		# Weak motor (0.0-1.0)
		1.0,		# Strong motor (0.0-1.0)
		0.25		# Duration in seconds
	)
	
	# Stuns the player
	stun_timer.start()
	# Play hurt animation
	linear_velocity = stun_speed * Vector2(0, 1)



func dash():
	if !dash_timer.is_stopped():
		return
	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)
	) 
	
	apply_impulse(input * dash_strength)
	dash_emitter.restart()
	
	Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		0.5,		# Weak motor (0.0-1.0)
		1,		# Strong motor (0.0-1.0)
		0.1		# Duration in seconds
	)
		
	dash_timer.start()


func _on_dash_cooldown_timeout() -> void:
	print("Dash ready: ", player_id )


func _on_parry_timer_timeout() -> void:
	parry_light.energy = 0
	parry_collision.energy = 0
	parry_sparks.emitting = false
