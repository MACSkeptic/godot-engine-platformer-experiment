extends Area2D

export (Shape2D) var COLLISION_SHAPE
export onready var COLLIDER = $Collider
export (int) var damage = 1

func _ready():
	COLLIDER.shape = COLLISION_SHAPE

func _on_HitBox_area_entered(hurtbox: Area2D) -> void:
	hurtbox.emit_signal('hit', damage)
