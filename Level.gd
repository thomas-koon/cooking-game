extends Node

var wave
var waveTimeLeft
export (Array) var waves: Array # time in seconds for each wave
onready var waveTimer : Timer =  $WaveTimer
onready var ui = get_node("UI")

# Called when the node enters the scene tree for the first time.
func _ready():
	wave = 0
	waveTimeLeft = waves[wave]
	ui.update_wave(wave)
	ui.update_timer(waveTimeLeft)
	waveTimer.start()

func _on_WaveTimer_timeout():
	waveTimeLeft-=1
	ui.update_timer(waveTimeLeft)
	waveTimer.start()
	if waveTimeLeft == 0:
		wave+=1
		waveTimeLeft = waves[wave]
		ui.update_wave(wave)
		ui.update_timer(waveTimeLeft)
	
