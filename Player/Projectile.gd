extends Node2D

onready var VISIBILITY_NOTIFIER = $VisibilityNotifier2D

export var velocity = Vector2.ZERO

func _ready() -> void:
	VISIBILITY_NOTIFIER.connect('viewport_exited', self, 'left_viewport')

func left_viewport(viewport):
	print("projectile dead")
	queue_free()

func _process(delta: float) -> void:
	position += velocity * delta
