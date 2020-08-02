extends ColorRect

onready var ResumeGameButton = $CenterContainer/VBoxContainer/ResumeGameButton

func _ready() -> void:
	get_tree().paused = true
	ResumeGameButton.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('pause'):
		get_tree().paused = !get_tree().paused
		queue_free()

func _on_ResumeGameButton_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_QuitToMainMenuButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://UI/Menus/StartMenu.tscn")

func _on_QuitGameButton_pressed() -> void:
	get_tree().quit()
