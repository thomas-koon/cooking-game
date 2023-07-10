extends KinematicBody

const MOUSE_SENSITIVITY = 0.04;
const GRAVITY = 40; # downward acceleration in m/s^2
const JUMP_IMPULSE = 30;
const KB_INTERPOLATION_SPEED = 3;
const SPEED = 50; # movement speed in m/s
const MAX_VERTICAL_VELOCITY = 20
var throw_strength
var velocity = Vector3.ZERO
var kb = Vector3.ZERO
var holding;
var hovering
var coins

var old_looking

onready var head = $Head;
onready var raycast = $Head/Camera/RayCast1;
onready var raycast2 = $Head/Camera/RayCast2;
onready var jump_raycast = $Head/Camera/JumpRaycast;
onready var camera = $Head/Camera;

# i swear this was the only way. it wouldnt work with get_tree()
onready var root = get_parent().get_parent().get_parent()
onready var ui = root.get_node("Interface/UI")

# Called when the node enters the scene tree for the first time.
func _ready():
	coins = 0
	ui.update_coins(coins)
	throw_strength = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # hide cursor

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-80), deg2rad(80))

func _physics_process(delta):
	if velocity.y > MAX_VERTICAL_VELOCITY:
		velocity.y = MAX_VERTICAL_VELOCITY
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
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		var obj = collision.get_collider()
		if obj == null:
		   continue
		else:
			if obj.is_in_group("projectile") and obj.has_method("hover_show"):
				if coins >= obj.price and !obj.shop_component.bought and obj.visible:
					coins = coins - obj.price
					obj.shop_component.bought = true
					ui.update_coins(coins)
	var new_looking = null
	if raycast2.is_colliding() and raycast2.get_collider() != null:
		if raycast2.get_collider().has_method("hover_show"):
			new_looking = raycast2.get_collider()
	if new_looking == old_looking:
		pass
	else:
		if old_looking == null and new_looking != null:
			new_looking.hover_show()
		elif new_looking == null and old_looking != null:
			old_looking.hover_hide()
		else:
			old_looking.hover_hide()
			new_looking.hover_show()
	old_looking = new_looking
	
	"""
		var looking = raycast2.get_collider()
		if looking == null:
			pass
		else:
			if looking.has_method("hover_show"):
				hovering = looking
				looking.hover_show()
		"""
	if(holding != null):
		holding.transform.origin = raycast.to_global(raycast.get_cast_to());
		holding.get_node("CollisionShape").disabled = true
		if Input.is_action_pressed("throw") and throw_strength < 4:
			throw_strength += 0.02
			raycast.rotation_degrees.x -= 0.2
		if Input.is_action_just_released("throw"):
			holding.get_node("CollisionShape").disabled = false
			var obj = holding
			holding = null; 
			raycast.rotation_degrees.x = 0
			obj.projectile_component.throw(obj, ((raycast.to_global((raycast.cast_to)))-raycast.to_global(Vector3.ZERO)), throw_strength)
			throw_strength = 0
	else:
		pass;
	if Input.is_action_just_pressed("pickup"):
		if(holding == null):
			if raycast.is_colliding():
				var obj = raycast.get_collider();
				if obj.is_in_group("projectile"):
					if obj.shop_component.bought:
						holding = obj;
						obj.get_node("CollisionShape").disabled = true
		else: # drop it
			holding = null;

func knockback(kb_dir, magnitude):
	kb += kb_dir * magnitude
	
