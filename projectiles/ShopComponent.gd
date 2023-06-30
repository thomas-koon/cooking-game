extends Node
class_name ShopComponent

export var price : int

const LOCKED_ROTATION_SPEED = 1.0
const LOCKED_BOB_SPEED = 1.0
const LOCKED_BOB_HEIGHT = 1.0
var initLockedPosition
var elapsedLockedTime
var bought

# Called when the node enters the scene tree for the first time.
func _ready():
	bought = false
	if price == 0:
		bought = true
	#nitLockedPosition = item.position

func spin(item, delta):
	item.rotation.y += LOCKED_ROTATION_SPEED * delta
