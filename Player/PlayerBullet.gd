extends "res://Player/Projectile.gd"

export onready var HITBOX = $HitBox

func _ready() -> void:
	set_process(false)

func disable_process():
	set_process(false)

func enable_process():
	set_process(true)


func _on_HitBox_area_entered(area: Area2D) -> void:
	print("bullet dead (hit enemy)")
	queue_free()
