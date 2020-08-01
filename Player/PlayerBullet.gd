extends "res://Player/Projectile.gd"

export onready var AREA = $Area

func _ready() -> void:
	set_process(false)
	AREA.connect('body_entered', self, "handle_collision")

func disable_process():
	set_process(false)

func enable_process():
	set_process(true)

func handle_collision(target):
	if target.name != 'Player':
		print('player bullet hit: ', self, target, target.name)
		queue_free()
	else:
		print('player bullet hit was ignored: ', self, target, target.name)
