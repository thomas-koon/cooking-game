extends KinematicBody

enum FoodType {HOT_DOG, PIZZA}

export var wave: int
export var distance: int
export (FoodType) var food_type

onready var request_bubble: Sprite3D = $Sprite3D
onready var player = get_tree().get_nodes_in_group("player")[0];
var velocity: Vector3
var showing_food
var initialized

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	initialized = false
	request_bubble.visible = false
	if food_type == FoodType.HOT_DOG:
		request_bubble.texture = load("res://assets/sprite/ask_hotdog.png")
	elif food_type == FoodType.PIZZA:
		request_bubble.texture = load("res://assets/sprite/ask_pizza.png")
	else:
		pass

func hover_show():
	print("shpwn")
	request_bubble.visible = true
	
func hover_hide():
	print("hide")
	request_bubble.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#hover_hide()
	if initialized == false and get_parent().get_parent().get_parent().wave == wave:
		initialized = true
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		var obj = collision.get_collider()
		if obj == null:
		   continue
		if obj.is_in_group("projectile"):
			if obj.ingredient_name == "hotdog" and food_type == FoodType.HOT_DOG:
				if obj.state == obj.States.MUSTARD:
					print("hot dog hit")
					obj.visible = false
					obj.get_node("CollisionShape").disabled = true
					obj.set_physics_process(false)
					visible = false
					get_node("CollisionShape").disabled = true
					set_physics_process(false)
			if obj.ingredient_name == "pizza" and food_type == FoodType.PIZZA:
				if obj.state == obj.States.COOKED:
					obj.visible = false
					obj.get_node("CollisionShape").disabled = true
					obj.set_physics_process(false)
					visible = false
					get_node("CollisionShape").disabled = true
					set_physics_process(false)
