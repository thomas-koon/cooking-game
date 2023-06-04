extends KinematicBody

const GRAVITY = 40;
var ROTATION_SPEED = 8;
var velocity = Vector3.ZERO;

enum States {IDLE, LOOKING, IN_AIR, ATTACKING}
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
	# USE STATES
	if _state == States.IDLE:
		# NO FRICTION. NO SLIDING
		pass
	if _state == States.LOOKING:
		# NO FRICTION. NO SLIDING
		look(delta, position, direction) 
	if _state == States.ATTACKING:
		# jump or dash
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
	var horizontalVelocity = direction.normalized() * distance * 0.25# Adjust the speed as needed
	velocity = horizontalVelocity + Vector3(0, verticalVelocity, 0)

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
			_state = States.ATTACKING
		elif _state == States.ATTACKING: # done attacking
			_state = States.IDLE
	pass # Replace with function body.
