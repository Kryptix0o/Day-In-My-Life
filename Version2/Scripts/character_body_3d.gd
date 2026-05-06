extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera_pivot: Node3D = $CameraPivot
var mouse_sensitivity := 0.002
var pitch := 0.0

var bob_time := 0.0
var camera_base_pos: Vector3
var walk_bob_intensity := 0.08
var idle_bob_intensity := 0.02
var bob_speed := 8.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	camera_base_pos = camera_pivot.position
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad (-15), deg_to_rad(40))
		camera_pivot.rotation.x = pitch

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		var is_moving := Vector2(velocity.x, velocity.z).length() > 0.1
		bob_time += delta * bob_speed
		var bob_amount := 0.0
		
		if is_moving:
			bob_amount = sin(bob_time) * walk_bob_intensity
		else:
			bob_amount = sin(bob_time) * idle_bob_intensity
			
			camera_pivot.position.y = camera_base_pos.y + bob_amount

	move_and_slide()
