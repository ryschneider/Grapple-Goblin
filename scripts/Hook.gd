extends RigidBody2D

const SPEED = 2000
const MIN_LENGTH = 50
const MAX_LENGTH = 500

var direction = Vector2()

var isHooked = false
var ropeLength = 0

@onready var Player = get_node("../Player")
var PinJoint = null

func _ready():
	destroy()

func destroy():
	isHooked = false
	ropeLength = 0
	hide()

func hook():
	isHooked = true
	
	var rope = position - Player.position
	ropeLength = rope.length()

var oldPlayerPos = Vector2()
func shootHook(): # called from Player.gd
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

func _process(dt):
	rotation = (position - Player.position).angle()

func _physics_process(dt):
	if is_visible() && !isHooked:
		if (position - Player.position).length() > MAX_LENGTH:
			destroy()
		
		var collision = move_and_collide(direction * SPEED * dt)
		if collision:
			if (position - Player.position).length() >= MIN_LENGTH:
				hook()
			else:
				destroy()
		
	if isHooked:
		var rope = position - Player.position
		if rope.length() >= ropeLength:
			var ropeDir = rope.normalized()
			Player.position += ropeDir * (rope.length() - ropeLength)
			Player.velocity -= ropeDir * Player.velocity.dot(ropeDir)