extends CharacterBody2D

const FLOOR_JUMP = -400
const GRAPPLE_JUMP = -300

const TOP_SPEED = 300

const FLOOR_ACC = 0.3
const FLOOR_FRICTION = 0.2

const AIR_ACC = 0.1
const AIR_FRICTION = 0.05

var GRAVITY = 980

var moveVel = Vector2()
var momentumVel = Vector2()

@onready var Hook = get_node("../Hook")

func grapple():
	Hook.direction = (get_global_mouse_position() - position).normalized()
	Hook.position = position
	Hook.show()

func ungrapple():
	Hook.destroy()

func _physics_process(delta):
	if not is_on_floor():
		momentumVel.y += GRAVITY * delta
	else:
		momentumVel.y = 0

	if Input.is_action_just_pressed("grapple"):
		grapple()
	elif Input.is_action_just_released("grapple"):
		ungrapple()

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			momentumVel.y += FLOOR_JUMP
		elif Hook.isHooked:
			momentumVel.y += GRAPPLE_JUMP
			ungrapple()

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		# approach direction TOP_SPEED
		moveVel = lerp(moveVel, direction * Vector2(TOP_SPEED, 0), FLOOR_ACC)
	else:
		# approach 0 by friction
		var friction
		if is_on_floor(): friction = FLOOR_FRICTION
		else: friction = AIR_FRICTION
		
		var velChange = momentumVel.x
		momentumVel.x = lerp(momentumVel.x, 0.0, friction)
		velChange = momentumVel.x - velChange
		if velChange < 5:
			moveVel.x = lerp(moveVel.x, 0.0, friction)
	
	moveVel = Hook.apply(moveVel)
	momentumVel = Hook.apply(momentumVel)
	if is_on_ceiling():
		moveVel.y = 0
		momentumVel.y = 0
	
	var moveDir = moveVel.normalized()
	var momentumDir = momentumVel.normalized()
	
	velocity = moveVel + momentumVel
	move_and_slide()
	if moveVel.length() > velocity.length():
		moveVel *= velocity.length() / moveVel.length()
#	moveVel = moveDir * min(TOP_SPEED, velocity.dot(moveDir))
	momentumDir = velocity - moveVel
	
#	print(moveVel)
#	print(momentumDir)
#	print()
