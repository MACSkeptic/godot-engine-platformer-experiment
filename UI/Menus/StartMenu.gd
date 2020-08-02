extends Control

func _ready() -> void:
	VisualServer.set_default_clear_color(Color(0.1, 0.1, 0.1))

func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://World/World.tscn")

func _on_LoadButton_pressed() -> void:
	pass # Replace with function body.

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
