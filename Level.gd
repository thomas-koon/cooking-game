extends Node

var wave
var waveTimeLeft
export (Array) var waves: Array # time in seconds for each wave
export var coins_per_mob: int
export var fall_threshold: int
onready var wave_seconds : Timer = get_node("WaveSeconds")
onready var pause_menu : Control = get_node("Interface/PauseMenu")
onready var ui = get_node("Interface/UI")
onready var player = get_node("Viewport3D/Viewport/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	wave = 0
	waveTimeLeft = waves[wave]
	ui.update_wave(wave)
	ui.update_timer(waveTimeLeft)
	wave_seconds.start()
	pause_menu.set_paused(false)
	for obj in get_node("Viewport3D/Viewport").get_children():
		if obj.is_in_group("wave_spawn"):
			if obj.wave == 0:
				obj.visible = true
			else:
				obj.visible = false
				obj.get_node("CollisionShape").disabled = true
				obj.set_physics_process(false)
	
func _physics_process(delta):
	for obj in get_node("Viewport3D/Viewport").get_children():
		if obj.is_in_group("wave_spawn"):
			if obj.visible == false and wave == obj.wave:
				obj.visible = true
				obj.get_node("CollisionShape").disabled = false
				obj.set_physics_process(true)
	if player.global_transform.origin.y < fall_threshold:
		fail_level()
	var mobs = get_tree().get_nodes_in_group("mob")
	for mob in mobs:
		if mob.global_transform.origin.y < fall_threshold:
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
