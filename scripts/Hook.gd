extends RigidBody2D

const SPEED = 4000
const MIN_LENGTH = 50
const MAX_LENGTH = 500

var direction = Vector2()

var isHooked = false
var isTaut = false
var ropeLength = 0

@export var allowGrapple = false

@onready var Player = get_node("../Player")
@onready var SFX = get_node("../Player/SFX")
var PinJoint = null

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	destroy()

func destroy():
	isHooked = false
	ropeLength = 0
	isTaut = false
	hide()

func hook():
	SFX.playHook()
	isHooked = true
	
	var rope = position - Player.position
	ropeLength = rope.length()

var oldPlayerPos = Vector2()
func shootHook(): # called from Player.gd
	if Global.canGrapple or allowGrapple:
		direction = (get_global_mouse_position() - Player.position).normalized()
		position = Player.position + direction # to fix rotation setting in physics
		oldPlayerPos = Player.position
		show()

func apply(vel): # apply grapple physics to velocity
	if isHooked:
		var rope = position - Player.position
		if rope.length() >= ropeLength:
			var ropeDir = rope.normalized()
			vel -= ropeDir * vel.dot(ropeDir)
	return vel

func _process(_dt):
	if not isHooked:
		rotation = (position - Player.position).angle()

func _physics_process(dt):
	if is_visible() && !isHooked:
		if (position - Player.position).length() > MAX_LENGTH:
			destroy()
			return
		
		var collision = move_and_collide(direction * SPEED * dt)
		if collision:
			if (position - Player.position).length() >= MIN_LENGTH:
				hook()
			else:
				destroy()
	
	if isHooked:
		if not move_and_collide(direction * dt * SPEED, true): # platform disappeared
			destroy()
			return
		
		var rope = position - Player.position
		if rope.length() >= ropeLength:
			var ropeDir = rope.normalized()
			Player.position += ropeDir * (rope.length() - ropeLength)
			Player.velocity -= ropeDir * Player.velocity.dot(ropeDir)
			isTaut = true
		else:
#			isTaut = false
			isTaut = true # always taut
