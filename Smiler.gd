extends KinematicBody

export var wave : int

const GRAVITY = 40;
const ROTATION_SPEED = 8;
const DASH_SPEED = 4;
const KB_INTERPOLATION_SPEED = 3;
const HORIZONTAL_JUMP_SPEED = 2
var velocity = Vector3.ZERO;
var kb = Vector3.ZERO
var dashing = false; # even if in DASHING state, this has to be true to dash
var dash_direction;
var justJumped = false;

signal dash_hit

enum States {IDLE, LOOKING, JUMPING, DASHING}
var _state : int = States.IDLE

onready var raycast = $RayCast
onready var player = get_tree().get_nodes_in_group("player")[0];
onready var stateTimer: Timer = $StateTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	if wave == 0:
		visible = true
	else:
		visible = false
	_state = States.IDLE
	stateTimer.start()

func _physics_process(delta):
	var position = player.global_transform.origin #player's position
	var direction = (position - global_transform.origin).normalized()
	var distance = global_transform.origin.distance_to(position)
	# USE STATES
	if _state == States.IDLE:
		velocity.x = 0
		velocity.z = 0
		pass
	if _state == States.LOOKING:
		# NO FRICTION. NO SLIDING
		velocity.x = 0
		velocity.z = 0
		look(delta, position, direction) 
	if _state == States.DASHING:
		if is_on_floor() and dashing:
			dash(dash_direction)
			pass
	if _state == States.JUMPING:
		if is_on_floor() and !justJumped:
			velocity.x = 0
			velocity.z = 0
			kb.x = 0
			kb.z = 0
			jump(distance, position, direction)
			justJumped = true 
		elif is_on_floor() and justJumped:
			velocity.x = 0
			velocity.z = 0
		else:
			pass
	velocity.y -= delta * GRAVITY;
	#apply knockback
	velocity.x += kb.x
	velocity.z += kb.z
	move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, false)
	kb = kb.linear_interpolate(Vector3.ZERO, KB_INTERPOLATION_SPEED * delta)
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		var obj = collision.get_collider()
		if obj == null:
		   continue
		if obj.is_in_group("projectile"):
			if _state == States.DASHING:
				if player.holding == obj:
					player.holding = null
					player.knockback(dash_direction, 2)
				else:
					obj.projectile_component.throw(obj, dash_direction, DASH_SPEED)
		if obj.is_in_group("player"):
			# if squashing the player
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# insta death?
				print("squash")
				pass
			else: # if not a squash
				if _state == States.DASHING:
					dashing = false
					velocity.x = 0
					velocity.z = 0
					player.knockback(dash_direction, 2)
					print("dash hit")
					
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# stop dash if about to fall off edge
	if raycast.get_collider() == null and _state == States.DASHING:
		velocity.x = 0
		velocity.z = 0
		dashing = false
	if get_parent().wave == wave:
		visible = true
	
func look(delta, position, direction):
	var targetRotation = direction.angle_to(Vector3(0, 0, -1))
	var currentRotation = global_transform.basis.get_euler().y
	rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), delta*ROTATION_SPEED)
	
func jump(distance, position, direction):
	var jumpHeight = abs((position.y - global_transform.origin.y) * 1.1)
	var verticalVelocity = sqrt(2.0 * GRAVITY * jumpHeight) 
	velocity.x = direction.x * distance
	velocity.y = verticalVelocity
	velocity.z = direction.z * distance
	
func dash(direction):
	var motion = direction * DASH_SPEED
	velocity.x = motion.x
	velocity.z = motion.z
	
func knockback(kb_dir, magnitude):
	kb += kb_dir * magnitude

func _on_StateTimer_timeout():
	#print(_state)
	# idle, look, attack (dash or jump), repeat
	var position = player.global_transform.origin #player's position
	var direction = position - transform.origin;
	var distance = global_transform.origin.distance_to(position)
	# only change states while grounded
	if !is_on_floor() || get_parent().wave < wave:
		_state = _state
	else:
		if _state == States.IDLE:
			_state = States.LOOKING
		elif _state == States.LOOKING:
			if distance > 40 || abs(position.y - global_transform.origin.y) > 1:
				_state = States.JUMPING
			else:
				dash_direction = direction
				_state = States.DASHING
				dashing = true
		elif _state == States.DASHING:
			dashing = false;
			_state = States.IDLE
		elif _state == States.JUMPING and justJumped:
			justJumped = false
			_state = States.IDLE
	pass # Replace with function body.
