extends RigidBody2D

const SPEED = 2000
const MIN_LENGTH = 10

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

func apply(vel): # apply grapple physics to velocity
	if isHooked:
		var rope = position - Player.position
		if rope.length() >= ropeLength:
			var ropeDir = rope.normalized()
			vel -= ropeDir * vel.dot(ropeDir)
	return vel

func _physics_process(dt):
	if is_visible() && !isHooked:
		var collision = move_and_collide(direction * SPEED * dt)
		if collision:
			hook()
	if isHooked:
		var rope = position - Player.position
		if rope.length() > ropeLength:
			var ropeDir = rope.normalized()
			Player.position += ropeDir * (rope.length() - ropeLength)
