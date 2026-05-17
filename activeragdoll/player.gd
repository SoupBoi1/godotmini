extends CharacterBody3D

var mouse_position = Vector2.ZERO
var total_pitch = 0.0
@export_range(0.0, 1.0) var sensitivity = 0.25


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var centreCameraMaker : Node3D = $Centre

@onready var axe: CharacterBody3D = $Hand/Axe

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		mouse_position = event.relative
		
func _update_mouselook():
	mouse_position *= sensitivity
	var yaw = mouse_position.x
	var pitch :float= mouse_position.y
	
	pitch = clamp(pitch, -50 - total_pitch, 50 - total_pitch)
	total_pitch += pitch

	rotate_y(deg_to_rad(-yaw))
	centreCameraMaker.rotate_x(deg_to_rad(-pitch))
	
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

	move_and_slide()

func _process(delta):
	_update_mouselook()
	
	if Input.is_action_just_pressed("throw"):
		if axe.state == axe.STATE.HELD:
			axe.throw()
		
	if Input.is_action_just_pressed("recall"):
		axe.recall()
		
