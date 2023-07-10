extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_StartButton_pressed():
	print("moo")
	get_tree().change_scene("res://DemoLevel.tscn")
	
