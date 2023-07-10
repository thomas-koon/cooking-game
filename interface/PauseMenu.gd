extends Control

var paused = false setget set_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		set_paused(!paused)

func set_paused(pause1):
	print(pause1)
	paused = pause1
	get_tree().paused = paused
	visible = paused
	if paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_ResumeBtn_pressed():
	set_paused(false)

func _on_QuitBtn_pressed():
	get_tree().reload_current_scene()
	get_tree().change_scene("res://interface/MainMenu.tscn")
