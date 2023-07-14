extends CharacterBody2D

const FLOOR_JUMP = -400
const GRAPPLE_JUMP = -300

const TOP_SPEED = 300

const FLOOR_ACC = 0.3
const FLOOR_FRICTION = 0.1

const AIR_ACC = 0.1
const AIR_FRICTION = 0.05

var GRAVITY = 980

var moveVel = Vector2()
var momentumVel = Vector2()

@onready var Hook = get_node("../Hook")

const CROUCH_FRAMES = 6
var crouchFrame = 0
var jumping = false
func _physics_process(delta):
	if not is_on_floor():
		momentumVel.y += GRAVITY * delta
	else:
		momentumVel.y = 0

	if Input.is_action_just_pressed("grapple"):
		Hook.shootHook()
	elif Input.is_action_just_released("grapple"):
		Hook.destroy()

	if Input.is_action_just_pressed("jump") and not jumping:
		if is_on_floor():
			jumping = true
			crouchFrame = 0
		elif Hook.isHooked:
			momentumVel.y += GRAPPLE_JUMP
			Hook.destroy()

	var direction = Input.get_axis("move_left", "move_right")
	
#	if direction != 0:
#		if is_on_floor() and (not Input.is_action_just_pressed("jump")):
#			$AnimatedSprite2D.play("Run")
#	else:
#		if is_on_floor():
#			$AnimatedSprite2D.play("Idle")
#	if Input.is_action_just_pressed("jump"):
#		$AnimatedSprite2D.frame = 0
	
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
	
#		var velChange = momentumVel.x
#		momentumVel.x = lerp(momentumVel.x, 0.0, friction)
#		velChange = momentumVel.x - velChange
#		if velChange < 1:
#			moveVel.x = lerp(moveVel.x, 0.0, friction)
	
	moveVel = Hook.apply(moveVel)
	momentumVel = Hook.apply(momentumVel)
	if is_on_ceiling() or (is_on_floor() and not Input.is_action_just_pressed("jump")):
		moveVel.y = 0
		momentumVel.y = 0
	
	# animation stuff
	if jumping:
		$AnimatedSprite2D.play("Jump")
		if crouchFrame >= CROUCH_FRAMES:
			momentumVel.y += FLOOR_JUMP
			$AnimatedSprite2D.frame = 1
			jumping = false
		else:
			$AnimatedSprite2D.frame = 0
			crouchFrame += 1
	else:
		if not is_on_floor():
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
