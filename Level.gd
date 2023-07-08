extends Node

var wave
var waveTimeLeft
export (Array) var waves: Array # time in seconds for each wave
export var coins_per_mob: int
export var mob_distance_threshold: int
export var fall_threshold: int
onready var wave_seconds : Timer =  $WaveSeconds
onready var pause_menu : Control = $PauseMenu
onready var ui = get_node("UI")
onready var player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	wave = 0
	waveTimeLeft = waves[wave]
	ui.update_wave(wave)
	ui.update_timer(waveTimeLeft)
	wave_seconds.start()
	pause_menu.set_paused(false)
	
func _physics_process(delta):
	if player.global_transform.origin.y < fall_threshold:
		fail_level()
	var mobs = get_tree().get_nodes_in_group("mob")
	for mob in mobs:
		print(player.global_transform.origin.distance_to(mob.global_transform.origin))
		if player.global_transform.origin.distance_to(
			mob.global_transform.origin) > mob_distance_threshold or \
			mob.global_transform.origin.y < fall_threshold:
			kill_mob(mob)
	
func kill_mob(mob):
	player.coins += 5
	ui.update_coins(player.coins)
	mob.queue_free()
	
func fail_level():
	print("fail")
	get_tree().quit()
	
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
			if wave >= waves.size() - 1:
				get_tree().quit()
			else:
				wave += 1
				waveTimeLeft = waves[wave]
				ui.update_wave(wave)
				ui.update_timer(waveTimeLeft)
		else:
			fail_level()
