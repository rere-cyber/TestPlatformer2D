extends KinematicBody2D

class_name Player 

const JUMP_FORCE = -170
const MAX_JUMP_RELEASE_FORCE = -100
const MAX_SPEED = 55
const ACCELERATION = 20
const FRICTION = 20
const ACCELERATION_OF_GRAVITY = 2
var velocity = Vector2.ZERO
var walk_speed = 50
var gravity = 4

onready var animatedSprite = get_node("AnimatedSprite")

func _ready():
	get_node("AnimatedSprite").frames = load("res://Animation/PlayerBlue.tres")

func _physics_process(delta):
	_apply_gravity()
	var currentDirection = Vector2.ZERO
	currentDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if currentDirection.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(currentDirection.x)
		animatedSprite.animation = "Run"
		
		if currentDirection.x > 0:
			animatedSprite.flip_h = true
		elif currentDirection.x < 0:
			animatedSprite.flip_h = false		
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
	else:
		animatedSprite.animation = "InAir"
		if Input.is_action_just_released("ui_up") and velocity.y < MAX_JUMP_RELEASE_FORCE:
			velocity.y = MAX_JUMP_RELEASE_FORCE			
		
		if velocity.y > 0:
			velocity.y +=ACCELERATION_OF_GRAVITY
	
	var was_in_air =  not is_on_floor()		
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1

func _apply_gravity():
		velocity.y +=gravity
		velocity.y = min(velocity.y, 200)
				
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(value):	
	velocity.x = move_toward(velocity.x, value * MAX_SPEED, ACCELERATION)

	
