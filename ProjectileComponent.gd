extends Node
class_name ProjectileComponent

var justThrown : bool
var throw_vec : Vector3
var launch : Vector3
var kb_strength
var throw_interpolation_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	justThrown = false
	throw_vec = Vector3.ZERO
	
func is_projectile():
	return true

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
				item.recipe(projectile) # each recipe component will have its own recipe() function
