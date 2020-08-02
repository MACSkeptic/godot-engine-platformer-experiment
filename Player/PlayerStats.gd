extends Resource
class_name PlayerStats

var MAX_HEALTH = 4
var health = MAX_HEALTH setget set_health

signal player_died
signal player_health_changed(new_health, old_health)


func set_health(new_health):
	var old_health = health
	print("player health changed from: ", health, "to: ", new_health)
	if new_health < health:
		Events.emit_signal('add_screen_shake', 1, 0.5)
	health = clamp(new_health, 0, MAX_HEALTH)
	emit_signal('player_health_changed', health, old_health)
	if health <= 0:
		emit_signal('player_died')
