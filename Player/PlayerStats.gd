extends Resource
class_name PlayerStats

var MAX_HEALTH = 4
var health = MAX_HEALTH setget set_health

signal player_died

func set_health(new_health):
	print("player health changed from: ", health, "to: ", new_health)
	health = clamp(new_health, 0, MAX_HEALTH)
	if health <= 0:
		emit_signal('player_died')
