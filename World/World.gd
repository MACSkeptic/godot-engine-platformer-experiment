extends Node2D

const PauseMenu = preload('res://UI/Menus/PauseMenu.tscn')
onready var UICanvas = $UI/CanvasLayer

func _ready() -> void:
	VisualServer.set_default_clear_color(Color(0.1, 0.1, 0.1))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('pause') and not get_tree().paused:
		var pause_menu = PauseMenu.instance()
		if not UICanvas == null:
			UICanvas.add_child(pause_menu)
		else:
			print("no ui found")
