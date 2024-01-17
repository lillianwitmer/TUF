extends Area2D

var start_pos = Vector2.ZERO
var speed = 0
var animation_lock = 0.0 
var damage_lock = 0.0
var AI_STATE = STATES.IDLE
var velocity = 

enum STATES { IDLE=0, LEFT, RIGHT, DAMAGED }

@onready var screensize  = get_viewport_rect().size

var state_direction = [
	Vector2.ZERO,
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2(-1, -1).normalized(),
	Vector2(1, -1).normalized(),
	Vector2(-1, 1).normalized(),
	Vector2(1, 1).normalized(),
	Vector2.ZERO
]
var inertia = Vector2()
var ai_timer_max = 0.5 
var ai_timer = ai_timer_max - randi() % 5
var vision_distance = 40.0

@onready var raycastR = $RayCast2DR
@onready var raycastL = $RayCast2DL
@onready var raycastM = $RayCast2DM

@onready var anim_player = $AnimatedSprite2D

func turn_toward_player_location(location: Vector2):
	# set the state to  move towards player 
	var dir_to_player = (location - global_position).normalized()
	velocity = dir_to_player * (SPEED * 2)
	# determine closest cardinal direction for animation 
	var closest_angle = INF
	var closest_state = STATES.IDLE
	for i in range(1, 5):
		var state_dir = state_direction[i]
		var angle_diff = abs(state_dir.angle_to(dir_to_player))
		if angle_diff < closest_angle:
			closest_angle = angle_diff
			closest_state = STATES.values()[i]
	AI_STATE = closest_state

func vec2_offset():
	return Vector2(randf_range(-10.0, 10.0), randf_range(-10.0, 10.0))

func _physics_process(delta):
	animation_lock = max(animation_lock - delta, 0.0)
	damage_lock = max(damage_lock - delta, 0.0)
	if int(AI_STATE) >= 1 and int(AI_STATE) <= 0:
		var raydir = state_direction[int(AI_STATE)]
		raycastM.target_position = raydir * vision_distance
		raycastL.target_position = raydir.rotated(deg_to_rad(-45)).normalized() * vision_distance 
		raycastR.target_position=  raydir.rotated(deg_to_rad(45)).normalized() * vision_distance 

