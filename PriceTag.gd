extends Spatial

onready var l_digit = get_node("LeftDigit")
onready var r_digit = get_node("RightDigit")
onready var player = get_tree().get_nodes_in_group("player")[0];

func billboard():
	var position = player.global_transform.origin #player's position
	var direction = (position - global_transform.origin).normalized()
	var rotation_angle = atan2(direction.x, direction.z)
	rotation.y = rotation_angle
	
func set_price(new_price):
	var price_str = str(new_price)
	if new_price < 10:
		l_digit.texture = load("res://assets/sprite/numbers/0.png")
		r_digit.texture = load("res://assets/sprite/numbers/" + price_str + ".png")
	else:
		l_digit.texture = load("res://assets/sprite/numbers/" + price_str[0]+ ".png")
		r_digit.texture = load("res://assets/sprite/numbers/" + price_str[1]+ ".png")
		
