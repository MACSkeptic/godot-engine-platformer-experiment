extends KinematicBody2D

export (int) var TARGET_FPS = 60
export (float) var PLAYER_ACCELERATION = 8 * TARGET_FPS
export (float) var PLAYER_MAX_SPEED = 64
export (float) var PLAYER_FRICTION_IN_AIR = 0.01
export (float) var PLAYER_FRICTION_IN_GROUND = 0.25
export (float) var PLAYER_GRAVITY = 8 * TARGET_FPS
export (float) var PLAYER_JUMP_FORCE = -3 * TARGET_FPS
export (float) var PLAYER_MAX_SLOPE_ANGLE = deg2rad(46)

var motion = Vector2.ZERO

var direction_input = Vector2.ZERO

var jump_input
var physics_delta

func read_direction_input():
	direction_input.x = Input.get_action_strength('player_right') - Input.get_action_strength('player_left')
	direction_input.y = Input.get_action_strength('player_down') - Input.get_action_strength('player_up')

func read_jump_input():
	jump_input = Input.is_action_just_pressed('player_jump')

func apply_player_acceleration():
	motion.x = clamp(motion.x + (direction_input.x * PLAYER_ACCELERATION * physics_delta), -PLAYER_MAX_SPEED, PLAYER_MAX_SPEED)

func apply_friction_to_motion():
	if (direction_input.x != 0):
		return
	motion.x = lerp(motion.x, 0, PLAYER_FRICTION_IN_GROUND)

func apply_gravity_to_motion():
	motion.y = motion.y + (PLAYER_GRAVITY * physics_delta)

func apply_jump_to_motion():
	if jump_input:
		motion.y = motion.y + (PLAYER_JUMP_FORCE)

func resolve_motion():
	motion = move_and_slide(motion, Vector2.UP, false, 4, PLAYER_MAX_SLOPE_ANGLE)

func apply_direction_input_to_sprite_direction():
	if direction_input.x != 0:
		$PlayerSprite.flip_h = direction_input.x < 0

func read_input():
	read_direction_input()
	read_jump_input()

func _physics_process(delta):
	physics_delta = delta

	read_input()

	apply_player_acceleration()
	apply_direction_input_to_sprite_direction()
	apply_friction_to_motion()
	apply_gravity_to_motion()
	apply_jump_to_motion()

	resolve_motion()
