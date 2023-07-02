extends Node
class_name ShopComponent

const LOCKED_ROTATION_SPEED = 1.0
const LOCKED_BOB_SPEED = 1.0
const LOCKED_BOB_HEIGHT = 1.0
var initLockedPosition
var elapsedLockedTime
var bought
var price

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setup(item):
	initLockedPosition = item.translation
	elapsedLockedTime = 0.0
	price = item.price
	if price == 0:
		bought = true
	else:
		bought = false

func bob_and_spin(item, delta):
	item.rotation.y += LOCKED_ROTATION_SPEED * delta
	elapsedLockedTime += delta
	var offset = Vector3(0, sin(elapsedLockedTime * LOCKED_BOB_SPEED) * LOCKED_BOB_HEIGHT, 0)
	item.translation = initLockedPosition + offset
	
func hover_show():
	pass
	
func hover_hide():
	pass
