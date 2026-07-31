extends RigidBody2D



@export var player_id := 0
@export var acceleration := 1000.0
@export var deadzone := 0.4

@export var dash_strength := 1000
@export var dash_cooldown := 2
@export var biteimpulse_strength := 100

@onready var dash_timer: Timer = $DashCooldown
@onready var bite_timer: Timer = $BiteCooldown
@onready var orbiting_sphere = $OrbitingSphere
@onready var melee_attack = $Bite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dash_timer.wait_time = dash_cooldown
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
	
	apply_central_force(input * acceleration)

var attack_previous := false

func _input(event):
	if Input.is_joy_button_pressed(player_id,JOY_BUTTON_LEFT_SHOULDER):
		dash()
	
	var attack_pressed = Input.is_joy_button_pressed(player_id, JOY_BUTTON_RIGHT_SHOULDER)
	if attack_pressed and !attack_previous:
		var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_Y)
		)
		var direction = input
		melee_attack.melee(player_id, direction)
		apply_impulse(direction.normalized() * biteimpulse_strength)
	
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
