extends KinematicBody

enum FoodType {HOT_DOG, PIZZA}
enum MovementType {HORIZONTAL, VERTICAL}

export var wave: int
export var distance: int
export var movement_speed: int
export (FoodType) var food_type
export (MovementType) var movement_type

onready var timer: Timer = $Timer
onready var request_bubble: Sprite3D = $Sprite3D
onready var player = get_tree().get_nodes_in_group("player")[0];
var movementDirection: int
var velocity: Vector3
var showing_food

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite3D.visible = false
	if food_type == FoodType.HOT_DOG:
		request_bubble.texture = load("res://assets/sprite/ask_hotdog.png")
	elif food_type == FoodType.PIZZA:
		request_bubble.texture = load("res://assets/sprite/ask_pizza.png")
	else:
		pass
	if movement_type == MovementType.HORIZONTAL:
		velocity = global_transform.basis.x
	if movement_type == MovementType.VERTICAL:
		velocity = global_transform.basis.y
	movementDirection = movement_speed
	timer.set_wait_time(distance / movement_speed)
	timer.start()
	pass # Replace with function body.
	
func show_food():
	request_bubble.visible = true
	
func hide_food():
	request_bubble.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# get parent wave or something like that
	# use a timer to change direction
	# time = distance/speed
	# if collide with food, disappear (for now)
	move_and_slide(movementDirection*velocity)
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		var obj = collision.get_collider()
		if obj == null:
		   continue
		if obj.is_in_group("projectile"):
			if obj.ingredient_name == "hotdog" and food_type == FoodType.HOT_DOG:
				if obj.state == obj.States.MUSTARD:
					obj.queue_free()
					player.last_viewed_customer = null
					queue_free()
			if obj.ingredient_name == "pizza" and food_type == FoodType.PIZZA:
				if obj.state == obj.States.COOKED:
					obj.queue_free()
					player.last_viewed_customer = null
					queue_free()
			

func _on_Timer_timeout():
	movementDirection *= -1
	timer.set_wait_time(distance / movement_speed)
	timer.start()
