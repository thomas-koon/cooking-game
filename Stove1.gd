extends KinematicBody

const GRAVITY = 200
const THROW_INTERPOLATION_SPEED = 5
const KNOCKBACK_STRENGTH = 50
var velocity = Vector3.ZERO;
var projectile_component : ProjectileComponent
var ingredient_name
var matching_ingredient
var has_pan

# Called when the node enters the scene tree for the first time.
func _ready():
	has_pan = false
	ingredient_name = "stove"
	matching_ingredient = ""
	projectile_component = ProjectileComponent.new()
	projectile_component.kb_strength = KNOCKBACK_STRENGTH
	projectile_component.throw_interpolation_speed = THROW_INTERPOLATION_SPEED

func is_projectile():
	return true
	
func add_pan():
	has_pan = true
	get_node("MeshInstance").mesh = load("res://assets/vox/stove_pan.vox")
	
func remove_pan():
	has_pan = false
	get_node("MeshInstance").mesh = load("res://assets/vox/stove.vox")
	# spawn a new pan
	
func recipe(pan):
	print("add_pan")
	if !has_pan:
		add_pan()
		pan.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#apply throwing 
	projectile_component.add_throw(self)
	velocity.y -= delta * GRAVITY;
	move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, false)
	projectile_component.slow_throw(self, delta)
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if (collision.get_collider() == null):
		   continue
		else:
			projectile_component.hit(self, collision)
