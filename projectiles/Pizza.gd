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
export var wave : int
export var price : int
var shop_component: ShopComponent
onready var price_tag: Spatial = $PriceTag

# Called when the node enters the scene tree for the first time.
func _ready():
	hover_hide()
	state = States.RAW
	ingredient_name = "pizza"
	matching_ingredients = ["pizza_oven"]
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

func cook():
	get_node("MeshInstance").mesh = load("res://assets/vox/cooked_pizza.vox")
	state = States.COOKED
	
func recipe(item):
	if item.ingredient_name == "tomato":
		if state == States.RAW:
			state = States.TOMATO
			get_node("MeshInstance").mesh = load("res://assets/vox/pizza_crust_tomato.vox")
			item.visible = false
			item.get_node("CollisionShape").disabled = true
			item.set_physics_process(false)
	elif item.ingredient_name == "cheese":
		if state == States.TOMATO:
			state = States.CHEESE
			get_node("MeshInstance").mesh = load("res://assets/vox/pizza_crust_tomato_cheese.vox")
			item.visible = false
			item.get_node("CollisionShape").disabled = true
			item.set_physics_process(false)
	elif item.ingredient_name == "pepperoni":
		if state == States.CHEESE:
			state = States.PEPPERONI
			get_node("MeshInstance").mesh = load("res://assets/vox/pizza_crust_tomato_cheese_pepperoni.vox")
			item.visible = false
			item.get_node("CollisionShape").disabled = true
			item.set_physics_process(false)
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shop_component.bought:
		hover_hide()
		projectile_component.update_projectile(self, delta)
	else:
		price_tag.billboard()
		shop_component.bob_and_spin(self, delta)
	
