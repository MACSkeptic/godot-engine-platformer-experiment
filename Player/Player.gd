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

var state = {}

func _ready():
	state.motion = Vector2.ZERO
	state.snap_vector = Vector2.ZERO
	state.direction_input = Vector2.ZERO
	state.jump_input = false
	state.jump_input_cancel = false
	state.physics_delta = 0
	state.on_floor = false
	state.was_on_floor_before_move = false
	state.is_on_floor_after_move = false
	state.motion_before_move = Vector2.ZERO
	state.position_before_move = Vector2.ZERO
	state.position_after_move = Vector2.ZERO

func reset_snap_vector():
	state.snap_vector = Vector2.DOWN * 4

func read_direction_input():
	state.direction_input.x = Input.get_action_strength('player_right') - Input.get_action_strength('player_left')
	state.direction_input.y = Input.get_action_strength('player_down') - Input.get_action_strength('player_up')

func read_jump_input():
	state.jump_input = Input.is_action_just_pressed('player_jump')
	state.jump_input_cancel = Input.is_action_just_released('player_jump')

func apply_player_acceleration():
	state.motion.x = clamp(
		state.motion.x + (
			state.direction_input.x * PLAYER_ACCELERATION * state.physics_delta
		), -PLAYER_MAX_SPEED, PLAYER_MAX_SPEED)

func apply_friction():
	if (state.direction_input.x == 0):
		state.motion.x = lerp(state.motion.x, 0, PLAYER_FRICTION_IN_GROUND)

func apply_gravity():
	if !state.on_floor:
		state.motion.y = min(state.motion.y + (PLAYER_GRAVITY * state.physics_delta), PLAYER_MAX_FALL_SPEED)

func apply_jump_start():
	if state.jump_input and state.on_floor:
		state.motion.y = state.motion.y + (PLAYER_JUMP_FORCE)
		state.snap_vector = Vector2.ZERO
		print("player jump: start")

func apply_jump_cancel():
	if state.jump_input_cancel and state.motion.y < PLAYER_JUMP_FORCE / 2:
		state.motion.y = PLAYER_JUMP_FORCE / 2
		print("player jump: cancel")

func apply_jump():
	apply_jump_start()
	apply_jump_cancel()

func hacky_fixes_for_sloppy_slopes_before_move():
	state.was_on_floor_before_move = state.on_floor
	state.position_before_move = position
	state.motion_before_move = state.motion

func avoid_hopping_after_climbing_a_slope():
	if state.was_on_floor_before_move and !state.is_on_floor_after_move and !state.jump_input:
		state.motion.y = 0
		position.y = state.position_before_move.y

func avoid_stopping_for_a_second_when_landing_on_a_slope():
	if !state.was_on_floor_before_move and state.is_on_floor_after_move:
		state.motion.x = state.motion_before_move.x

func prevent_sliding_on_a_slope():
	if state.is_on_floor_after_move and get_floor_velocity().length() == 0 and abs(state.motion.x) < 1:
		position.x = state.position_before_move.x

func hacky_fixes_for_sloppy_slopes_after_move():
	state.is_on_floor_after_move = is_on_floor()
	state.position_after_move = position
	avoid_stopping_for_a_second_when_landing_on_a_slope()
	avoid_hopping_after_climbing_a_slope()
	prevent_sliding_on_a_slope()

func resolve_motion():
	hacky_fixes_for_sloppy_slopes_before_move()
	state.motion = move_and_slide_with_snap(state.motion, state.snap_vector, Vector2.UP, true, 4, PLAYER_MAX_SLOPE_ANGLE)
	hacky_fixes_for_sloppy_slopes_after_move()

func determine_sprite_direction():
	if state.direction_input.x != 0:
		SPRITE.flip_h = state.direction_input.x < 0

func read_input():
	read_direction_input()
	read_jump_input()

func check_on_floor():
	state.on_floor = is_on_floor()

func play_animation():
	if !state.on_floor:
		SPRITE_ANIMATOR.play('Jump')
	elif state.direction_input.x != 0:
		SPRITE_ANIMATOR.play('Walk')
	else:
		SPRITE_ANIMATOR.play('Idle')

func _physics_process(delta):
	state.physics_delta = delta

	read_input()

	check_on_floor()

	determine_sprite_direction()
	reset_snap_vector()

	apply_player_acceleration()
	apply_friction()
	apply_gravity()
	apply_jump()

	play_animation()

	resolve_motion()
