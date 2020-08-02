extends "res://Enemies/Enemy.gd"

export onready var RAYCAST_FLOOR_LEFT = $RayCastFloorLeft
export onready var RAYCAST_FLOOR_RIGHT = $RayCastFloorRight
export onready var RAYCAST_WALL_LEFT = $RayCastWallLeft
export onready var RAYCAST_WALL_RIGHT = $RayCastWallRight
export onready var SPRITE = $Sprite
export onready var COLLIDER = $Collider
export onready var ANIMATION_PLAYER = $AnimationPlayer

enum DIRECTION { LEFT = -1, RIGHT = 1 }

export (DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT

var state
var motion_before_move
var motion_after_move

func _ready() -> void:
	state = WALKING_DIRECTION

func update_motion_right_or_left():
	match state:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			if not RAYCAST_FLOOR_RIGHT.is_colliding() or RAYCAST_WALL_RIGHT.is_colliding():
				state = DIRECTION.LEFT
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			if not RAYCAST_FLOOR_LEFT.is_colliding() or RAYCAST_WALL_LEFT.is_colliding():
				state = DIRECTION.RIGHT

func determine_sprite_direction():
	SPRITE.scale.x = sign(motion.x)

func resolve_move():
	motion_before_move = motion
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(46))
	motion_after_move = motion

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	update_motion_right_or_left()
	determine_sprite_direction()
	resolve_move()
