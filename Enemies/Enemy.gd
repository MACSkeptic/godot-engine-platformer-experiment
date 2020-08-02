extends KinematicBody2D

const ExplosionEffect = preload('res://Effects/ExplosionEffect.tscn')

export (float) var MAX_SPEED = 15
export onready var stats = $EnemyStats

var motion = Vector2.ZERO

func _on_HurtBox_hit(damage) -> void:
	stats.health -= damage

func _on_EnemyStats_enemy_died() -> void:
	Utils.instance_scene_on_main(ExplosionEffect, global_position + Vector2(4, -4))
	queue_free()
