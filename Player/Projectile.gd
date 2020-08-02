extends Node2D

onready var VISIBILITY_NOTIFIER = $VisibilityNotifier2D

export var velocity = Vector2.ZERO

func _ready() -> void:
	VISIBILITY_NOTIFIER.connect('viewport_exited', self, 'left_viewport')

func left_viewport(_viewport):
	print("projectile dead (left screen)")
	queue_free()

func _process(delta: float) -> void:
	position += velocity * delta

# warning-ignore:unused_argument
func _on_HitBox_body_entered(body: Node) -> void:
	print("projectile dead (hit the wall)")
	queue_free()
