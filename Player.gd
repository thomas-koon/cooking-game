extends KinematicBody

const MOUSE_SENSITIVITY = 0.04;
const GRAVITY = 40; # downward acceleration in m/s^2
const JUMP_IMPULSE = 20;
export var speed = 10; # movement speed in m/s
var velocity = Vector3.ZERO

onready var head = $Head;

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # hide cursor
	
func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-80), deg2rad(80))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	# player's movement (unit) vector
	var direction = Vector3.ZERO
	
	# jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += JUMP_IMPULSE

	# moving in a single direction
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	# If pressing multiple keys, movement vector will need to be normalized.
	# that means turning its length to 1 while keeping the direction.
	# it's been a while since math
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# acceleration
	# Gravity is increased when descending, based on air time.
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= delta * GRAVITY;
	
	# move_and_slide() actually moves the player. Smooths out collisions
	velocity = move_and_slide(velocity, Vector3.UP)

