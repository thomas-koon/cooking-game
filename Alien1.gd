extends KinematicBody

const GRAVITY = 40;
var ROTATION_SPEED = 8;
var DASH_SPEED = 10;
var velocity = Vector3.ZERO;
var dashing = false;
var dash_direction;
var justJumped = false;

enum States {IDLE, LOOKING, JUMPING, DASHING}
var _state : int = States.IDLE

onready var player = get_tree().get_nodes_in_group("player")[0];
onready var stateTimer: Timer = $StateTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	stateTimer.start()
	pass # Replace with function body.

func _physics_process(delta):
	var position = player.global_transform.origin
	var direction = (position - global_transform.origin).normalized()
	var distance = global_transform.origin.distance_to(position)
	# USE STATES
	if _state == States.IDLE:
		velocity.x = 0
		velocity.z = 0
		pass
	if _state == States.LOOKING:
		# NO FRICTION. NO SLIDING
		look(delta, position, direction) 
	if _state == States.DASHING:
		if is_on_floor():
			dash(dash_direction)
	if _state == States.JUMPING:
		if is_on_floor() and !justJumped:
			jump(direction, distance)
			justJumped = true
		elif is_on_floor() and justJumped:
			velocity.x = 0
			velocity.z = 0
		else:
			pass
	velocity.y -= delta * GRAVITY;
	move_and_slide(velocity, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func look(delta, position, direction):
	var targetRotation = direction.angle_to(Vector3(0, 0, -1))
	var currentRotation = global_transform.basis.get_euler().y
	rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), delta*ROTATION_SPEED)
	
func jump(direction, distance):
	# clean up this code
	var jumpHeight = distance;
	var verticalVelocity = sqrt(2.0 * GRAVITY * jumpHeight)
	var horizontalVelocity = direction.normalized() * distance * 0.5# Adjust the speed as needed
	velocity = horizontalVelocity + Vector3(0, verticalVelocity, 0)
	
func dash(direction):
	var motion = direction * DASH_SPEED
	velocity.x = motion.x
	velocity.z = motion.z

func _on_StateTimer_timeout():
	print(_state)
	# idle, look, attack (dash or jump), repeat
	var direction = player.transform.origin - transform.origin;
	var distance = global_transform.origin.distance_to(player.global_transform.origin)
	# only change states while grounded
	if !is_on_floor():
		_state = _state
	else:
		if _state == States.IDLE:
			_state = States.LOOKING
		elif _state == States.LOOKING:
			if distance > 20:
				_state = States.JUMPING
			else:
				dash_direction = direction
				_state = States.DASHING
		elif _state == States.DASHING:
			_state = States.IDLE
		elif _state == States.JUMPING and justJumped:
			justJumped = false
			_state = States.IDLE
	pass # Replace with function body.

func _on_DashTimer_timeout():
	dashing = false
