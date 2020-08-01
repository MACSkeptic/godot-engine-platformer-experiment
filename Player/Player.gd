extends KinematicBody2D

export (int) var TARGET_FPS = 60
export (float) var PLAYER_ACCELERATION = 8 * TARGET_FPS
export (float) var PLAYER_MAX_SPEED = 64
export (float) var PLAYER_FRICTION_IN_AIR = 0.01
export (float) var PLAYER_FRICTION_IN_GROUND = 0.25
export (float) var PLAYER_GRAVITY = 8 * TARGET_FPS
export (float) var PLAYER_JUMP_FORCE = -3 * TARGET_FPS
export (float) var PLAYER_MAX_SLOPE_ANGLE = deg2rad(46)
export (float) var PLAYER_MAX_FALL_SPEED = -1.5 * PLAYER_JUMP_FORCE
export onready var SPRITE = $PlayerSprite
export onready var SPRITE_ANIMATOR = $PlayerSpriteAnimator

var motion = Vector2.ZERO
var direction_input = Vector2.ZERO
var jump_input = false
var jump_input_cancel = false
var physics_delta = 0
var on_floor = false

func read_direction_input():
	direction_input.x = Input.get_action_strength('player_right') - Input.get_action_strength('player_left')
	direction_input.y = Input.get_action_strength('player_down') - Input.get_action_strength('player_up')

func read_jump_input():
	jump_input = Input.is_action_just_pressed('player_jump')
	jump_input_cancel = Input.is_action_just_released('player_jump')

func apply_player_acceleration():
	motion.x = clamp(motion.x + (direction_input.x * PLAYER_ACCELERATION * physics_delta), -PLAYER_MAX_SPEED, PLAYER_MAX_SPEED)

func apply_friction():
	if (direction_input.x == 0):
		motion.x = lerp(motion.x, 0, PLAYER_FRICTION_IN_GROUND)

func apply_gravity():
	motion.y = min(motion.y + (PLAYER_GRAVITY * physics_delta), PLAYER_MAX_FALL_SPEED)

func apply_jump_start():
	if jump_input and on_floor:
		motion.y = motion.y + (PLAYER_JUMP_FORCE)
		print("player jump: start")

func apply_jump_cancel():
	if jump_input_cancel and motion.y < PLAYER_JUMP_FORCE / 2:
		motion.y = PLAYER_JUMP_FORCE / 2
		print("player jump: cancel")

func apply_jump():
	apply_jump_start()
	apply_jump_cancel()

func resolve_motion():
	motion = move_and_slide(motion, Vector2.UP, false, 4, PLAYER_MAX_SLOPE_ANGLE)

func determine_sprite_direction():
	if direction_input.x != 0:
		SPRITE.flip_h = direction_input.x < 0

func read_input():
	read_direction_input()
	read_jump_input()

func check_on_floor():
	on_floor = is_on_floor()

func play_animation():
	if !on_floor:
		SPRITE_ANIMATOR.play('Jump')
	elif direction_input.x != 0:
		SPRITE_ANIMATOR.play('Walk')
	else:
		SPRITE_ANIMATOR.play('Idle')

func _physics_process(delta):
	physics_delta = delta

	read_input()

	check_on_floor()

	determine_sprite_direction()

	apply_player_acceleration()
	apply_friction()
	apply_gravity()
	apply_jump()

	play_animation()

	resolve_motion()
