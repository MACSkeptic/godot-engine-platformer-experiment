extends KinematicBody2D

const ExplosionEffect = preload('res://Effects/ExplosionEffect.tscn')

export (float) var MAX_SPEED = 15
var motion = Vector2.ZERO


func _on_HurtBox_hit(damage) -> void:
	Utils.instance_scene_on_main(ExplosionEffect, global_position + Vector2(4, -4))
	queue_free()
