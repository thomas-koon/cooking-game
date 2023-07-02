extends KinematicBody

const MOUSE_SENSITIVITY = 0.04;
const GRAVITY = 40; # downward acceleration in m/s^2
const JUMP_IMPULSE = 20;
const KB_INTERPOLATION_SPEED = 3;
const SPEED = 40; # movement speed in m/s
var throw_strength
var velocity = Vector3.ZERO
var kb = Vector3.ZERO
var holding;
var hovering

onready var head = $Head;
onready var raycast = $Head/Camera/RayCast;
onready var raycast2 = $Head/Camera/RayCast2;
onready var camera = $Head/Camera;

# Called when the node enters the scene tree for the first time.
func _ready():
	throw_strength = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # hide cursor

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-80), deg2rad(80))

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
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	velocity.y -= delta * GRAVITY;
	velocity.x += kb.x
	velocity.z += kb.z
	# move_and_slide() actually moves the player. Smooths out collisions
	velocity = move_and_slide(velocity, Vector3.UP)
	kb = kb.linear_interpolate(Vector3.ZERO, KB_INTERPOLATION_SPEED * delta)

func _process(_delta):
	if raycast2.is_colliding():
		var looking = raycast2.get_collider()
		if looking == null:
			pass
		else:
			if looking.has_method("hover_show"):
				hovering = looking
				looking.hover_show()
	else:
		if hovering != null:
			if hovering.has_method("hover_hide"):
				hovering.hover_hide()
	
	if(holding != null):
		holding.transform.origin = raycast.to_global(raycast.get_cast_to());
		if Input.is_action_pressed("throw") and throw_strength < 4:
			throw_strength += 0.02
		if Input.is_action_just_released("throw"):
			var obj = holding
			holding = null; 
			obj.projectile_component.throw(obj, ((raycast.to_global((raycast.cast_to)))-raycast.to_global(Vector3.ZERO)), throw_strength)
			throw_strength = 0
	else:
		pass;
	if Input.is_action_just_pressed("pickup"):
		if(holding == null):
			if raycast.is_colliding():
				var obj = raycast.get_collider();
				if obj.is_in_group("projectile"):
					holding = obj;
		else: # drop it
			holding = null;

func knockback(kb_dir, magnitude):
	kb += kb_dir * magnitude
	
