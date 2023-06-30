extends KinematicBody

const GRAVITY = 200
const THROW_INTERPOLATION_SPEED = 5
const KNOCKBACK_STRENGTH = 50
var velocity = Vector3.ZERO;
var projectile_component : ProjectileComponent
var ingredient_name
var matching_ingredients
var has_pan

# Called when the node enters the scene tree for the first time.
func _ready():
	has_pan = false
	ingredient_name = "pizza_oven"
	matching_ingredients = [""]
	projectile_component = ProjectileComponent.new()
	projectile_component.kb_strength = KNOCKBACK_STRENGTH
	projectile_component.throw_interpolation_speed = THROW_INTERPOLATION_SPEED

func is_projectile():
	return true
	
func recipe(item):
	if item.ingredient_name == "pizza":
		if item.state == item.States.PEPPERONI:
			item.cook()
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
