extends Node2D

signal enemy_died

export (int) var MAX_HEALTH = 1
onready var health = MAX_HEALTH setget set_health

func set_health(new_health):
	print("enemy stats changed - health from: ", health, ", to: ", new_health)
	health = clamp(new_health, 0, MAX_HEALTH)
	if (health <= 0):
		emit_signal('enemy_died')
