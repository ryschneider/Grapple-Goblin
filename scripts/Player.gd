extends CharacterBody2D

const FLOOR_JUMP = -420
const GRAPPLE_JUMP = -300

const TOP_SPEED = 300

const FLOOR_ACC = 0.3
const FLOOR_FRICTION = 0.1

const AIR_ACC = 0.1
const AIR_FRICTION = 0.05

var GRAVITY = 980

const MAX_CLIP = 10

const JUMP_QUEUE_TIME = 6.0 / 60.0

var moveVel = Vector2()
var momentumVel = Vector2()

@onready var Hook = get_node("../Hook")

const DEATH_TIME = 2
var died = false
var diedTime = 0
func die():
	died = true
	diedTime = 0
	if $AnimatedSprite2D.animation != "Dead":
		$AnimatedSprite2D.play("Dead")

var direction = 0
var jumpQueued = false
var jumpQueueTime = 0.0
func _physics_process(delta):
	if died: return
	
	if not is_on_floor():
		momentumVel.y += GRAVITY * delta
	else:
		momentumVel.y = 0

	if Input.is_action_just_pressed("grapple"):
		Hook.shootHook()
	elif Input.is_action_just_released("grapple"):
		Hook.destroy()

	if jumpQueued:
		jumpQueueTime += delta
		if jumpQueueTime > JUMP_QUEUE_TIME:
			jumpQueued = false
	
	if Input.is_action_just_pressed("jump") or jumpQueued:
		if is_on_floor():
			$AudioStreamPlayer2D.play(0.05)
			if jumpQueued: jumpQueued = false
			
			momentumVel.y += FLOOR_JUMP
		elif Hook.isHooked:
			$AudioStreamPlayer2D.play(0.05)
			if jumpQueued: jumpQueued = false
			
			momentumVel.y += GRAPPLE_JUMP
			Hook.destroy()
		elif not jumpQueued:
			jumpQueued = true
			jumpQueueTime = 0

#	var direction = Input.get_axis("move_left", "move_right")
	# handle inputs with priority for movement direction just pressed
	if Input.is_action_just_pressed("move_left") and Input.is_action_just_pressed("move_right"):
		direction = 0
	elif Input.is_action_just_pressed("move_left"):
		direction = -1
	elif Input.is_action_just_pressed("move_right"):
		direction = 1
	elif Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		direction = -1
	elif Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		direction = 1
	elif not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		direction = 0
	
	# movement
	if direction != 0:
		# approach direction TOP_SPEED
		moveVel = lerp(moveVel, direction * Vector2(TOP_SPEED, 0), FLOOR_ACC)
		
		if sign(moveVel.x) != sign(momentumVel.x):
			var shift
			if abs(moveVel.x) > abs(momentumVel.x):
				shift = -momentumVel.x
			else:
				shift = moveVel.x
			
			momentumVel.x += shift
			moveVel.x -= shift
	else:
		# approach 0 by friction
		var friction
		if is_on_floor(): friction = FLOOR_FRICTION
		else: friction = AIR_FRICTION
		
		var totalX = momentumVel.x + moveVel.x
		var dx = lerp(totalX, 0.0, friction) - totalX
		
		if sign(momentumVel.x + dx) == sign(dx):
			moveVel.x += dx - momentumVel.x
			momentumVel.x = 0
		else:
			momentumVel.x += dx
	
	moveVel = Hook.apply(moveVel)
	momentumVel = Hook.apply(momentumVel)
	if is_on_ceiling() and moveVel.y + momentumVel.y < 0:
		moveVel.y = 0
		momentumVel.y = 0
	if is_on_floor() and moveVel.y + momentumVel.y > 0:
		moveVel.y = 0
		momentumVel.y = 0
	
	# animation stuff
	if not is_on_floor():
		if $AnimatedSprite2D.animation != "Jump":
			$AnimatedSprite2D.play("Jump")
	elif direction != 0:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")
	
	# combine velocities
	var moveDir = moveVel.normalized()
	var momentumDir = momentumVel.normalized()
	
	velocity = moveVel + momentumVel
	move_and_slide()
	
	# seperate velocities
	if moveVel.length() > velocity.length():
		moveVel *= velocity.length() / moveVel.length()
#	moveVel = moveDir * min(TOP_SPEED, velocity.dot(moveDir))
	momentumDir = velocity - moveVel
	
	# flips sprite
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false

func _on_area_2d_body_entered(body):
	var pos = position
	var clip = 5
	
	var c = 0
	while clip <= MAX_CLIP:
		position = pos - Vector2(0, clip)
		if not move_and_collide(Vector2(), true): # try clipping up
			print(c)
			return
		
		position = pos + Vector2(0, clip)
		if not move_and_collide(Vector2(), true): # try clipping down
			print(c)
			return
		
		clip *= 1.5
		c += 1
	
	die() # failed to clip out
