extends KinematicBody2D
export (float) var MAX_SPEED = 15
var motion = Vector2.ZERO


func _on_HurtBox_hit(damage) -> void:
	queue_free()
