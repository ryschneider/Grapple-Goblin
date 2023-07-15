extends CharacterBody2D

const FLOOR_JUMP = -420
const GRAPPLE_JUMP = -300

const TOP_SPEED = 300

const FLOOR_ACC = 0.3
const FLOOR_FRICTION = 0.1

const AIR_ACC = 0.1
const AIR_FRICTION = 0.02

const GRAVITY = 980

const MAX_CLIP = 10

const JUMP_QUEUE_TIME = 6.0 / 60.0

const TERRAIN_LAYER = 1 << (1 - 1)
const HAZARD_LAYER = 1 << (3 - 1)
const RESTART_LAYER = 1 << (4 - 1)
const PREV_LAYER = 1 << (5 - 1)
const NEXT_LAYER = 1 << (6 - 1)

var moveVel = Vector2()
var momentumVel = Vector2()

@onready var Hook = get_node("../Hook")

const DEATH_TIME = 1
var dead = false
var deadTime = 0
func die():
	if dead: return
	
	dead = true
	deadTime = 0
	if $AnimatedSprite2D.animation != "Dead":
		$AnimatedSprite2D.play("Dead")
	
	Hook.destroy()
	direction = 0

func restart():
	get_tree().reload_current_scene()

const LIMIT_GRACE = 30

var direction = 0
var jumpQueued = false
var jumpQueueTime = 0.0
func _physics_process(delta):
	if dead:
		if deadTime < DEATH_TIME and not Input.is_action_just_pressed("grapple"):
			deadTime += delta
		else:
			dead = false
			restart()
	
	if not is_on_floor():
		momentumVel.y += GRAVITY * delta
	else:
		momentumVel.y = 0

	if not dead:
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
	if not dead:
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
	
	# kill if off camera
#	if position.x+LIMIT_GRACE < $Camera2D.limit_left or position.x-LIMIT_GRACE > $Camera2D.limit_right\
#		or position.y+LIMIT_GRACE < $Camera2D.limit_top or position.y-LIMIT_GRACE > $Camera2D.limit_bottom:
	if $Camera2D:
		if position.y < $Camera2D.limit_top or position.y > $Camera2D.limit_bottom:
			restart()

func _on_area_2d_area_entered(area):
	if area.collision_layer & HAZARD_LAYER:
		die()
	elif area.collision_layer & RESTART_LAYER:
		restart()
	elif area.collision_layer & PREV_LAYER:
		if not dead:
			get_parent().prevScreen()
	elif area.collision_layer & NEXT_LAYER:
		if not dead:
			get_parent().nextScreen()

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		if PhysicsServer2D.body_get_collision_layer(body_rid) & HAZARD_LAYER:
			die()
		elif PhysicsServer2D.body_get_collision_layer(body_rid) & TERRAIN_LAYER:
			clipUp()

func clipUp():
	print("clip up")
	var pos = position
	var clip = 5
	
	while clip <= MAX_CLIP:
		position = pos - Vector2(0, clip)
		if not move_and_collide(Vector2(), true): # try clipping up
			return
		
		position = pos + Vector2(0, clip)
		if not move_and_collide(Vector2(), true): # try clipping down
			return
		
		clip *= 1.5
	
	die() # failed to clip out

