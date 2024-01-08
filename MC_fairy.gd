extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum STATES { IDLE = 0, DEAD, DAMAGED, ATTACKING, DASHING }

@export var data = {
	"max_health": 60.0,  # 20hp per heart; 5 per fraction
	"health": 60.0,      # Min 60 Max 400
	"state": STATES.IDLE,
	"secondaries": [],
}
func get_direction_name():
	return ["right", "down", "left", "up"][
		int(round(look_direction.angle() * 2 / PI)) % 4
]
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_on = true
var look_direction = Vector2.RIGHT
var screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("ui_left"):
		velocity.x += 1
	if Input.is_action_pressed("ui_right"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED

func _physics_process(delta):
# Add the gravity.
	if not is_on_floor() and gravity_on :
		velocity.y += gravity * delta

	if Input.is_action_just_pressed(KEY_D):
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
		update_animation(direction)
	move_and_slide()
	
@onready var anim = $AnimatedSprite2D
func update_animation(direction):
	if not is_on_floor():
		anim.play("idle")
	elif direction != 0:
		anim.play("walk_right")
		anim.flip_h = direction < 0 
	else:
		anim.play("idle")



