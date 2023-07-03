extends KinematicBody

const GRAVITY = 200
const THROW_INTERPOLATION_SPEED = 5
const KNOCKBACK_STRENGTH = 20
export var price : int
var velocity = Vector3.ZERO;
var projectile_component : ProjectileComponent
var ingredient_name
var matching_ingredients

var shop_component: ShopComponent
onready var price_tag: Spatial = $PriceTag

enum States {BUN, SAUSAGE, MUSTARD}
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	state = States.BUN
	ingredient_name = "hotdog"
	matching_ingredients = []
	shop_component = ShopComponent.new()
	shop_component.setup(self)
	projectile_component = ProjectileComponent.new()
	projectile_component.kb_strength = KNOCKBACK_STRENGTH
	projectile_component.throw_interpolation_speed = THROW_INTERPOLATION_SPEED
	projectile_component.gravity = GRAVITY

func hover_show():
	if !shop_component.bought:
		price_tag.visible = true
	
func hover_hide():
	price_tag.visible = false

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
	hover_hide()
	if shop_component.bought:
		projectile_component.update_projectile(self, delta)
	else:
		price_tag.billboard()
		shop_component.bob_and_spin(self, delta)
	
