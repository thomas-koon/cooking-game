extends Node

var wave
var waveTimeLeft
export (Array) var waves: Array # time in seconds for each wave
onready var wave_seconds : Timer =  $WaveSeconds
onready var pause_menu : Control = $PauseMenu
onready var ui = get_node("UI")

# Called when the node enters the scene tree for the first time.
func _ready():
	wave = 0
	waveTimeLeft = waves[wave]
	ui.update_wave(wave)
	ui.update_timer(waveTimeLeft)
	wave_seconds.start()
	pause_menu.set_paused(false)
	
func getCurrentCustomers():
	var nodes = get_tree().get_nodes_in_group("customer")
	var count = 0
	for node in nodes:
		if node.is_visible_in_tree():
			count += 1
	return count

func _on_WaveSeconds_timeout():
	waveTimeLeft-=1
	ui.update_timer(waveTimeLeft)
	wave_seconds.start()
	if waveTimeLeft == 0:
		if getCurrentCustomers() == 0:
			print("wave cleared")
			if wave >= waves.size() - 1:
				print("win")
				get_tree().quit()
			else:
				wave += 1
				waveTimeLeft = waves[wave]
				ui.update_wave(wave)
				ui.update_timer(waveTimeLeft)
		else:
			print("wave failed")
			get_tree().quit()
