extends KinematicBody

const GRAVITY = 200
const THROW_INTERPOLATION_SPEED = 5
const KNOCKBACK_STRENGTH = 20
var velocity = Vector3.ZERO;
var projectile_component : ProjectileComponent
var ingredient_name
var matching_ingredients

enum States {BUN, SAUSAGE, MUSTARD}
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	state = States.BUN
	ingredient_name = "hotdog"
	matching_ingredients = []
	projectile_component = ProjectileComponent.new()
	projectile_component.kb_strength = KNOCKBACK_STRENGTH
	projectile_component.throw_interpolation_speed = THROW_INTERPOLATION_SPEED

func is_projectile():
	return true

func recipe(item):
	if item.ingredient_name == "sausage":
		if item.cooked and state == States.BUN:
			state = States.SAUSAGE
			get_node("MeshInstance").mesh = load("res://assets/vox/hot_dog.vox")
			item.queue_free()
	elif item.ingredient_name == "mustard":
		if state == States.SAUSAGE:
			state = States.MUSTARD
			get_node("MeshInstance").mesh = load("res://assets/vox/hot_dog_mustard.vox")
			item.queue_free()
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#apply throwing 
	projectile_component.add_throw(self)
	velocity.y -= delta * GRAVITY;
	move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, false)
	projectile_component.slow_throw(self, delta)
	projectile_component.detect_collision(self)
	
