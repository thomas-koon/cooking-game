extends KinematicBody

const GRAVITY = 200
const THROW_INTERPOLATION_SPEED = 5
const KNOCKBACK_STRENGTH = 50
export var price : int
export var wave : int
var velocity = Vector3.ZERO;
var projectile_component : ProjectileComponent
var shop_component : ShopComponent
var ingredient_name
var matching_ingredients
var has_pan

onready var price_tag: Spatial = $PriceTag

# Called when the node enters the scene tree for the first time.
func _ready():
	hover_hide()
	has_pan = false
	ingredient_name = "stove"
	matching_ingredients = [""]
	shop_component = ShopComponent.new()
	shop_component.setup(self)
	hover_hide()
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
	
func add_pan():
	has_pan = true
	get_node("MeshInstance").mesh = load("res://assets/vox/stove_pan.vox")
	
func remove_pan():
	has_pan = false
	get_node("MeshInstance").mesh = load("res://assets/vox/stove.vox")
	# spawn a new pan
	
func recipe(item):
	if item.ingredient_name == "pan":
		if !has_pan:
			add_pan()
			item.visible = false
			item.get_node("CollisionShape").disabled = true
			item.set_physics_process(false)
	elif item.ingredient_name == "sausage":
		if item.cooked == false and has_pan == true:
			item.cook()
			remove_pan()
			var new_pan = load("res://projectiles/Pan.tscn")
			var spawn_pan = new_pan.instance()
			spawn_pan.translation = global_transform.origin
			spawn_pan.translation.y += 10
			get_parent().add_child(spawn_pan)
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
