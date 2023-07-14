extends CharacterBody2D

const JUMP_VELOCITY = -600.0

const TOP_SPEED = 300
const FRICTION = 0.1
const RUN_ACC = 0.3

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

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

	if Input.is_action_just_pressed("grapple"):
		grapple()
	elif Input.is_action_just_released("grapple"):
		ungrapple()

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			momentumVel.y += JUMP_VELOCITY
		elif Hook.isHooked:
			momentumVel.y += JUMP_VELOCITY
			ungrapple()

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		# approach direction TOP_SPEED
		moveVel.x = lerp(moveVel.x, direction * TOP_SPEED, RUN_ACC)
	else:
		# approach 0 by friction
		var velChange = momentumVel.x
		momentumVel.x = lerp(momentumVel.x, 0.0, FRICTION)
		velChange = momentumVel.x - velChange
		if velChange < 5:
			moveVel.x = lerp(moveVel.x, 0.0, FRICTION)
	
	velocity = moveVel + momentumVel
	
	move_and_slide()
