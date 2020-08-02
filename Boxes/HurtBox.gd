extends Area2D

export (Shape2D) var COLLISION_SHAPE
export onready var COLLIDER = $Collider

func _ready():
	COLLIDER.shape = COLLISION_SHAPE

# warning-ignore:unused_signal
signal hit(damage)
