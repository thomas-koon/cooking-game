extends KinematicBody

const GRAVITY = 200
const THROW_INTERPOLATION_SPEED = 5
const KNOCKBACK_STRENGTH = 50
var velocity = Vector3.ZERO;
var projectile_component : ProjectileComponent
var ingredient_name
var matching_ingredients
var has_pan
export var wave : int
export var price : int
var shop_component: ShopComponent
onready var price_tag: Spatial = $PriceTag

# Called when the node enters the scene tree for the first time.
func _ready():
	has_pan = false
	ingredient_name = "pizza_oven"
	matching_ingredients = [""]
	shop_component = ShopComponent.new()
	shop_component.setup(self)
	projectile_component = ProjectileComponent.new()
	projectile_component.kb_strength = KNOCKBACK_STRENGTH
	projectile_component.throw_interpolation_speed = THROW_INTERPOLATION_SPEED
	projectile_component.gravity = GRAVITY

func is_projectile():
	return true
	
func hover_show():
	if !shop_component.bought:
		price_tag.visible = true
	
func hover_hide():
	price_tag.visible = false

func recipe(item):
	if item.ingredient_name == "pizza":
		if item.state == item.States.PEPPERONI:
			item.cook()
	else:
		pass
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	hover_hide()
	if shop_component.bought:
		projectile_component.update_projectile(self, delta)
	else:
		price_tag.billboard()
		shop_component.bob_and_spin(self, delta)
