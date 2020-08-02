extends "res://Player/Projectile.gd"

export onready var HITBOX = $HitBox

func _ready() -> void:
	set_process(false)

func disable_process():
	set_process(false)

func enable_process():
	set_process(true)

