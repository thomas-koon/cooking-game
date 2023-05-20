extends KinematicBody

const GRAVITY = 40;
var velocity = Vector3.ZERO;

onready var player = get_tree().get_nodes_in_group("player")[0];
onready var jumpTimer: Timer = $JumpTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	jumpTimer.start()
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y -= delta * GRAVITY;
	if Input.is_action_just_pressed("test"):
		_jump()
	move_and_slide(velocity, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_direction = player.transform.origin - transform.origin;
	# look at player when grounded
	if is_on_floor():
		look_at(global_transform.origin - player_direction, Vector3.UP);
		rotation.x = 0;
		rotation.z = 0;
		
func _jump():
	# clean up this code
	var player_direction = player.transform.origin - transform.origin;
	player_direction.y = 0.0
	var distance = player_direction.length()
	var jumpHeight = distance;
	var verticalVelocity = sqrt(2.0 * GRAVITY * jumpHeight)
	var horizontalVelocity = player_direction.normalized() * distance * 0.25# Adjust the speed as needed
	velocity = horizontalVelocity + Vector3(0, verticalVelocity, 0)

func _on_JumpTimer_timeout():
	# do some checks first
	if is_on_floor():
		_jump()
		jumpTimer.wait_time = rand_range(1.0, 3.0)
		jumpTimer.start()
