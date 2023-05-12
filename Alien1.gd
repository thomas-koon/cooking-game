extends KinematicBody

const GRAVITY = 40;
var velocity = Vector3.ZERO;

onready var player = get_tree().get_nodes_in_group("player")[0];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y -= delta * GRAVITY;
	velocity = move_and_slide(velocity, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_direction = player.transform.origin - transform.origin;
	# look at player when grounded
	if is_on_floor():
		look_at(global_transform.origin - player_direction, Vector3.UP);
		rotation.x = 0;
		rotation.z = 0;
	

