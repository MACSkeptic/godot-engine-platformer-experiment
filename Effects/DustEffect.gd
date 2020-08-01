extends Node2D

export (Vector2) var min_range = Vector2(-20, -40)
export (Vector2) var max_range = Vector2(20, -10)
export (Vector2) var motion = Vector2(rand_range(min_range.x, max_range.x), rand_range(min_range.y, max_range.y))

func _process(delta: float) -> void:
	position += motion * delta
