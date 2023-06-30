extends KinematicBody

const GRAVITY = 200
const THROW_INTERPOLATION_SPEED = 5
const KNOCKBACK_STRENGTH = 20
var velocity = Vector3.ZERO;
var projectile_component : ProjectileComponent
var ingredient_name
var matching_ingredients

enum States {RAW, CHEESE, TOMATO, PEPPERONI, COOKED}
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	state = States.RAW
	ingredient_name = "pizza"
	matching_ingredients = ["pizza_oven"]
	projectile_component = ProjectileComponent.new()
	projectile_component.kb_strength = KNOCKBACK_STRENGTH
	projectile_component.throw_interpolation_speed = THROW_INTERPOLATION_SPEED

func is_projectile():
	return true

func cook():
	get_node("MeshInstance").mesh = load("res://assets/vox/cooked_pizza.vox")
	state = States.COOKED
	
func recipe(item):
	if item.ingredient_name == "tomato":
		if state == States.RAW:
			state = States.TOMATO
			get_node("MeshInstance").mesh = load("res://assets/vox/pizza_crust_tomato.vox")
			item.queue_free()
	elif item.ingredient_name == "cheese":
		if state == States.TOMATO:
			state = States.CHEESE
			get_node("MeshInstance").mesh = load("res://assets/vox/pizza_crust_tomato_cheese.vox")
			item.queue_free()
	elif item.ingredient_name == "pepperoni":
		if state == States.CHEESE:
			state = States.PEPPERONI
			get_node("MeshInstance").mesh = load("res://assets/vox/pizza_crust_tomato_cheese_pepperoni.vox")
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
	
