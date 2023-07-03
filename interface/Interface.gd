extends Control

onready var coin_counter = $CoinCounter/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_coins(coins):
	coin_counter.text = str(coins)
