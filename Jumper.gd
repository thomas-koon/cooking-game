extends RigidBody

onready var player = get_tree().get_nodes_in_group("player")[0];
onready var attackTimer: Timer = $AttackTimer
var gravity = -9.8

# Called when the node enters the scene tree for the first time.
func _ready():
	attackTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass
	
func look_follow(state, current_transform, target_position):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
	state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))

func _integrate_forces(state):
	var target_position = player.get_global_transform().origin
	# if on floor: look
	#look_follow(state, get_global_transform(), target_position)

