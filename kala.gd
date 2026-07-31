extends RigidBody2D

@export var player_id := 0
@export var acceleration := 1000.0
@export var max_speed := 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var thrust := 500.0

func _physics_process(delta):
	var input = Vector2(
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_id, JOY_AXIS_LEFT_Y)
	)


	if input.length() < 0.2:
		input = Vector2.ZERO

	apply_central_force(input * acceleration)

	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
