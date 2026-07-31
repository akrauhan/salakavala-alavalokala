extends RigidBody2D

@export var player_id := 0
@export var orbit_radius := 32.0
@export var orbit_speed := 2.0
@export var orbit_acceleration := 1000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var angle := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void:
	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_RIGHT_Y)
	)
	if input.length() < 0.2:
		input = Vector2.ZERO
		

	apply_central_force(input * orbit_acceleration + spring_force())

func spring_force():
	var distance = global_position-get_parent().global_position
	var rest_position = distance.normalized()*orbit_radius
	
	var d = distance - rest_position
	
	var force = -  distance.length() * d

	return force
