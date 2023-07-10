extends Node

var wave
var waveTimeLeft
export (Array) var waves: Array # time in seconds for each wave
export var fall_threshold: int
onready var wave_seconds : Timer = get_node("WaveSeconds")
onready var pause_menu : Control = get_node("Interface/PauseMenu")
onready var ui = get_node("Interface/UI")
onready var player = get_node("Viewport3D/Viewport/Player")

var total_wave_customers
var new_wave

# Called when the node enters the scene tree for the first time.
func _ready():
	total_wave_customers = 0
	wave = 0
	waveTimeLeft = waves[wave]
	ui.update_wave(wave)
	ui.update_timer(waveTimeLeft)
	wave_seconds.start()
	pause_menu.set_paused(false)
	for obj in get_node("Viewport3D/Viewport").get_children():
		if obj.is_in_group("customer") and obj.wave == 0:
			total_wave_customers += 1
		if obj.is_in_group("wave_spawn"):
			if obj.wave == 0:
				obj.visible = true
				obj.remove_from_group("wave_spawn")
			else:
				obj.visible = false
				obj.get_node("CollisionShape").disabled = true
				obj.set_physics_process(false)
	ui.update_customers(total_wave_customers, total_wave_customers)
	
func _physics_process(delta):
	var player_pos = player.global_transform.origin
	for obj in get_node("Viewport3D/Viewport").get_children():
		if obj.is_in_group("wave_spawn"):
			if obj.visible == false and wave == obj.wave:
				print("spawned")
				obj.remove_from_group("wave_spawn")
				obj.visible = true
				obj.get_node("CollisionShape").disabled = false
				obj.set_physics_process(true)
	if player_pos.y < fall_threshold:
		fail_level()
	var mobs = get_tree().get_nodes_in_group("mob")
	for mob in mobs:
		var mob_pos = mob.global_transform.origin
		if mob_pos.y < fall_threshold:
			if mob.just_got_hit:
				kill_mob(mob)
			else:
				var closest_respawn_distance = INF
				var closest_respawn = null
				for respawn_point in get_tree().get_nodes_in_group("respawn"):
					var distance = respawn_point.global_transform.origin.distance_to(mob_pos)
					if distance < closest_respawn_distance:
						closest_respawn_distance = distance
						closest_respawn = respawn_point
				mob.velocity.x = 0
				mob.velocity.y = 0
				mob.velocity.z = 0
				mob.global_transform.origin = closest_respawn.global_transform.origin
				
func kill_mob(mob):
	player.coins += mob.coins
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
	if new_wave:
		total_wave_customers = getCurrentCustomers()
		new_wave = false
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
				new_wave = true
		else:
			fail_level()
	ui.update_customers(getCurrentCustomers(), total_wave_customers)
