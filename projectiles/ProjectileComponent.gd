extends Node
class_name ProjectileComponent

var gravity
var justThrown : bool
var throw_vec : Vector3
var launch : Vector3
var kb_strength
var throw_interpolation_speed

onready var player = get_tree().get_nodes_in_group("player")[0];

# Called when the node enters the scene tree for the first time.
func _ready():
	justThrown = false
	throw_vec = Vector3.ZERO
	
func is_projectile():
	return true
	
func update_projectile(projectile, delta):
	#apply throwing 
	add_throw(projectile)
	projectile.velocity.y -= delta * gravity;
	projectile.move_and_slide(projectile.velocity, Vector3.UP, false, 4, 0.785398, false)
	slow_throw(projectile, delta)
	detect_collision(projectile)

func throw(projectile, dir, mag):
	justThrown = true
	projectile.velocity.y = sqrt(2.0 * projectile.GRAVITY * 0.9)
	throw_vec += dir * mag

func add_throw(projectile):
	projectile.velocity.x += throw_vec.x
	projectile.velocity.y += throw_vec.y
	projectile.velocity.z += throw_vec.z
	
func slow_throw(projectile, delta):
	throw_vec = throw_vec.linear_interpolate(Vector3.ZERO, throw_interpolation_speed * delta)
	
func detect_collision(projectile):
	for index in range(projectile.get_slide_count()):
		var collision = projectile.get_slide_collision(index)
		if (collision.get_collider() == null):
			continue
		else:
			hit(projectile, collision)
	
func hit(projectile, collision):
	if justThrown:
		justThrown = false
		# knocking back a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1: # on top
				# bounce?
				pass
			else: # if not on top
				mob.knockback(throw_vec, kb_strength)
		projectile.velocity.x = 0; projectile.velocity.y = 0; projectile.velocity.z = 0;
		throw_vec.x = 0; throw_vec.y = 0; throw_vec.z = 0;
		# part of a recipe?
		if collision.get_collider().is_in_group("projectile"):
			var item = collision.get_collider()
			if projectile.matching_ingredients.has(item.ingredient_name):
				# collided.recipe(thrown)
				if item.shop_component.bought:
					item.recipe(projectile) # each recipe component will have its own recipe() function
