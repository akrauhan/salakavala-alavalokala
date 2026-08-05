extends RigidBody2D

@export var player_id := 0
@export var orbit_radius := 75.0
@export var orbit_speed := 2.0
@export var orbit_acceleration := 2000.0

@export var orb_speed := 10.0

@onready var light: PointLight2D = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var angle := 0.0

var toggle_light_previous := false

func _process(delta: float) -> void:
	var toggle_pressed = Input.is_joy_button_pressed(player_id, JOY_BUTTON_LEFT_SHOULDER)
	
	if toggle_pressed and !toggle_light_previous:
		toggle_light()
	
	toggle_light_previous = toggle_pressed
	

func _physics_process(delta: float) -> void:
	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_Y)
	)
	if input.length() < 0.1:
		input = Vector2.ZERO
		

	apply_central_force(orb_speed * input * orbit_acceleration + spring_force())

func spring_force():
	var distance = global_position-get_parent().global_position
	var rest_position = distance.normalized()*orbit_radius
	
	if distance.length() < orbit_radius:
		return Vector2.ZERO
	
	var d = distance - rest_position
	
	var force = -  10 * distance.length() * d

	return force
	
var light_on = true

func _input(event):
	pass
	

func toggle_light():
	if light_on:
		light.energy = 0
		
	else:
		light.energy = 5
		
	light_on =  !light_on
