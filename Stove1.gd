extends KinematicBody

const GRAVITY = 200
const THROW_INTERPOLATION_SPEED = 5;
var velocity = Vector3.ZERO;
var throw = Vector3.ZERO
var throw_direction;
var justThrown

# Called when the node enters the scene tree for the first time.
func _ready():
	justThrown = false
	pass # Replace with function body.

func throw(throw_dir, magnitude):
	#velocity.y += 70
	justThrown = true
	throw_direction = throw_dir
	velocity.y = sqrt(2.0 * GRAVITY * 0.9)
	throw += throw_dir * magnitude

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#apply throwing 
	velocity.x += throw.x
	velocity.y += throw.y
	velocity.z += throw.z
	# TODO thrown and hit the floor
	velocity.y -= delta * GRAVITY;
	move_and_slide(velocity, Vector3.UP, false, 4, 0.785398, false)
	throw = throw.linear_interpolate(Vector3.ZERO, THROW_INTERPOLATION_SPEED * delta)
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if (collision.get_collider() == null):
		   continue
		else:
			if justThrown:
				print("hit")
				velocity.x = 0; velocity.y = 0; velocity.z = 0;
				throw.x = 0; throw.y = 0; throw.z = 0;
				justThrown = false
				if collision.get_collider().is_in_group("mob"):
					var mob = collision.get_collider()
					if Vector3.UP.dot(collision.get_normal()) > 0.1: # on top
						# bounce?
						pass
					else: # if not on top
						mob.knockback(throw_direction, 50)
