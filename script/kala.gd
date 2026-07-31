extends RigidBody2D
@onready var flapper_animation: AnimatedSprite2D = $Sprite2D/FlapperAnimation

@export var player_id := 0
@export var acceleration := 1000.0
@export var deadzone := 0.4

@export var dash_strength := 300
@export var dash_cooldown := 2
@export var flap_strength := 100
@export var flap_cooldown := 0.5
@export var biteimpulse_strength := 100

@onready var dash_timer: Timer = $DashCooldown
@onready var bite_timer: Timer = $Bite/BiteCooldown
@onready var flap_timer: Timer = $FlapCooldown
@onready var orbiting_sphere = $OrbitingSphere
@onready var melee_attack = $Bite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dash_timer.wait_time = dash_cooldown
	flap_timer.wait_time = flap_cooldown
	orbiting_sphere.player_id = player_id
	melee_attack.player_id = player_id
	


var toggle_light_previous := false


	
	
@export var thrust := 500.0

func _physics_process(delta):
	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)
	)
	
	if input.length() < deadzone:
		input = Vector2.ZERO
		flapper_animation.play("loop")
	flap(input)
	
	
	if Input.is_joy_button_pressed(player_id,JOY_BUTTON_LEFT_SHOULDER):
		dash()
	
	var input2 = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_Y)
	)
	
	rotation = input2.angle()
	
	var attack_pressed = Input.is_joy_button_pressed(player_id, JOY_BUTTON_RIGHT_SHOULDER)
	if attack_pressed and !attack_previous:
		var direction = input2
		
		if melee_attack.attack(direction):
			apply_impulse(direction.normalized()*biteimpulse_strength)



func flap(direction):
	if direction == Vector2.ZERO:
		return
	
	if !flap_timer.is_stopped():
		return
	
	apply_impulse(direction.normalized() * flap_strength)
	flap_timer.start()

var attack_previous := false

	
func take_damage():
	print("Player ", player_id, "hit")

func dash():
	if !dash_timer.is_stopped():
		return
	
	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)
	)	
	apply_impulse(input * dash_strength)
		
	dash_timer.start()



	

func _on_dash_cooldown_timeout() -> void:
	print("Dash ready: ", player_id )
