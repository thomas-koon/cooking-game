extends Control

onready var coin_counter = $CoinCounter/Label
onready var wave = $Wave
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_coins(coins):
	coin_counter.text = str(coins)

func update_wave(new_wave):
	wave.text = str("Wave ", new_wave)
	
func update_timer(seconds):
	var minutes = (seconds/60)%60
	var seconds1 = seconds%60
	timer.text = str("%02d:%02d" % [minutes, seconds1])
	
