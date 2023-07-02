extends HBoxContainer

var price : int

onready var l_digit = get_node("LeftDigit")
onready var r_digit = get_node("RightDigit")

# Called when the node enters the scene tree for the first time.
func _ready():
	price = 0

func set_price(new_price):
	var price_str = str(new_price)
	if price < 10:
		l_digit.texture = load("res://assets/sprite/numbers/0.png")
		r_digit.texture = load("res://assets/sprite/numbers/" + price_str + ".png")
	else:
		l_digit.texture = load("res://assets/sprite/numbers/" + price_str[1]+ ".png")
		r_digit.texture = load("res://assets/sprite/numbers/" + price_str[0]+ ".png")
		
