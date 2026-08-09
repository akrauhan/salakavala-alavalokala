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
@onready var bite_duration: Timer = $Bite/BiteDuration
@onready var flap_timer: Timer = $FlapCooldown
@onready var stun_timer: Timer = $StunTimer
@onready var parry_timer: Timer = $Parry/ParryTimer
@onready var dodge_timer: Timer = $Parry/DodgeTimer


@onready var ability_timer: Timer = $AbilityCooldown
@export var ability_cooldown := 3 # How long until the cooldown replenishes from 0 to 100%
var ability_charge := 1.0 # always 1, meaning 100%

@onready var orbiting_sphere = $OrbitingSphere
@onready var melee_attack = $Bite
@onready var parry_area = $Parry/ParryExplosionArea
@onready var dodge_area: Area2D = $Parry/DodgeArea

@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var parry_sound: AudioStreamPlayer2D = $Parry/ParrySound

@export var hurt_sounds: Array[AudioStream]

@export var rotation_speed = 8.0
@export var rotation_acceleration = 50.0

var start_pos: Vector2
var player_health
var default_collision_layer : int

signal took_damage
signal health_depleted(player_id) # emitted when player_health reaches 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dash_timer.wait_time = dash_cooldown
	flap_timer.wait_time = flap_cooldown
	stun_timer.wait_time = stun_time
	orbiting_sphere.player_id = player_id
	melee_attack.player_id = player_id
	start_pos = global_position
	default_collision_layer = collision_layer
	player_health = -1 # default is unlimited, active gamemode changes this after spawning
	


@export var thrust := 500.0


func _physics_process(delta):
	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)
	)
	
	if input.length() < deadzone and stun_timer.is_stopped():
		input = Vector2.ZERO
		flapper_animation.play("loop")
	flap(input)
	
	ability_charge = min(ability_charge + delta / ability_cooldown, 1.0)
	


	# DASH_INPUT
	if Input.get_joy_axis(player_id,JOY_AXIS_TRIGGER_LEFT) >= 0.5:
		dash()
	
	var input2 = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_Y)
	)
	
	if bite_duration.is_stopped(): # Lock rotation when attacking
		var target_angle = input2.angle()
		var angle_difference = wrapf(target_angle-rotation, -PI, PI)
		
		var target_angular_velocity = angle_difference * rotation_speed
		
		angular_velocity = move_toward(
			angular_velocity,
			target_angular_velocity,
			rotation_acceleration * delta
		)

	var attack_pressed = Input.get_joy_axis(player_id,JOY_AXIS_TRIGGER_RIGHT) >= 0.2
	if attack_pressed:

		var direction = input2	
		if ability_charge >= 1.0:
			if melee_attack.attack(direction):
				use_ability(1.0)
				
				linear_velocity = Vector2.ZERO
				angular_velocity = 0
				apply_impulse(direction.normalized()*biteimpulse_strength)


func flap(direction):
	if direction == Vector2.ZERO:
		flapper_emitter.emitting = false
		return
	flapper_emitter.emitting = true
	if !flap_timer.is_stopped() or !bite_duration.is_stopped():
		return
	
	apply_impulse(direction.normalized() * flap_strength)
	Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		0.05,		# Weak motor (0.0-1.0)
		0,		# Strong motor (0.0-1.0)
		0.125		# Duration in seconds
	)
	flap_timer.start()



func take_damage(attacker_id):

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
		parry_light.energy = 2
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
	
	
	took_damage.emit(attacker_id, player_id)
	print("Player ", player_id, " took damage from " , attacker_id)
	if player_id < hurt_sounds.size():
		hurt_sound.stream = hurt_sounds[player_id]
	hurt_sound.play()
	blood_animation.play("blood")  
	
	
	Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		1.0,		# Weak motor (0.0-1.0)
		1.0,		# Strong motor (0.0-1.0)
		0.25		# Duration in seconds
	)
	
	if player_health > 0: # -1 means unlimited health
		player_health -= 1
		if player_health == 0:
			health_depleted.emit(player_id)			
			return
					
	
	# Stuns the player
	stun_timer.start()
	# Play hurt animation
	linear_velocity = stun_speed * Vector2(0, 1)



func dash():

	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)
	) 
	
	if not use_ability(0.4):
		return
	
	apply_impulse(input * dash_strength)
	dash_emitter.restart()
	
	Input.start_joy_vibration(
		player_id,	# Controller to vibrate
		0.5,		# Weak motor (0.0-1.0)
		1,		# Strong motor (0.0-1.0)
		0.1		# Duration in seconds
	)
		
	

func use_ability(cost):
	if ability_charge < 1.0:
		return false
	
	ability_charge -= cost
	return true

func _on_dash_cooldown_timeout() -> void:
	print("Dash ready: ", player_id )


func _on_parry_timer_timeout() -> void:
	parry_light.energy = 0
	parry_collision.energy = 0
	parry_sparks.emitting = false
	

func eliminate():
	visible = false
	collision_layer = 0
	collision_mask = 0
	
func revive():
	visible = true
	collision_layer = 1
	collision_mask = 1
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	
