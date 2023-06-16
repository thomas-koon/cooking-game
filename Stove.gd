extends RigidBody

signal hit

var justThrown

# Called when the node enters the scene tree for the first time.
func _ready():
	justThrown = false
	contact_monitor = true
	contacts_reported = 10
	pass # Replace with function body.

func throw(vector):
	justThrown = true
	apply_central_impulse(vector)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Stove_body_entered(body):
	if body.is_in_group("mob"):
		if justThrown:
			justThrown = false
			body.knockback(linear_velocity, 6)
			linear_velocity.x = 0
			linear_velocity.z = 0
		else: 
			linear_velocity.x = 0
			linear_velocity.z = 0
		
