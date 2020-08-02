extends Control

var PlayerStats = ResourceLoader.PlayerStats

onready var Gauge = $Gauge
onready var Full = $Full

func _ready() -> void:
	PlayerStats.connect('player_health_changed', self, 'handle_player_health_changed')

func handle_player_health_changed(new_health, old_health):
	Gauge.value = new_health
	Full.rect_size.x = new_health * 5 + 1
