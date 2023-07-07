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

func _on_ResumeBtn_pressed():
	paused = false

func _on_QuitBtn_pressed():
	get_tree().quit()
