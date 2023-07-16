extends Node2D

@onready var player = get_node("../Player")
@onready var music = get_node("../Player/Music")
@onready var screenNode = get_node(".")

enum MUSIC { MAIN, BOSS }
@export var theme = MUSIC.MAIN

@export var fireScene = true
@export var forceDimension = false
@export var staticCamera = false
@export var playerStart = Vector2()

enum DIRECTION { LEFT, RIGHT, UP, DOWN }

## Direction=Right,Left: x position of the teleporter edge |||||||||||||||
## Direction=Top,Bottom: y position of the teleporter edge
#@export var startTeleportEdge = 0
## Direction=Right,Left: y position of the floor next to teleporter |||||||||||||||
## Direction=Top,Bottom: x position of the wall to the left of teleporter
@export var startTeleportBase = 0
## Direction you would exit to start the level
@export var startTeleportExitDirection = DIRECTION.RIGHT

## Direction=Right,Left: x position of the teleporter edge |||||||||||||||
## Direction=Top,Bottom: y position of the teleporter edge
#@export var endTeleportEdge = 0
## Direction=Right,Left: y position of the floor next to teleporter |||||||||||||||
## Direction=Top,Bottom: x position of the wall to the left of teleporter
@export var endTeleportBase = 0
## Direction you would enter to leave the level
@export var endTeleportEnterDirection = DIRECTION.RIGHT

var teleported = false

const WIDTH_OFFSET = 20
const HEIGHT_OFFSET = 20
func teleport(edge, base, direction):
	var cam
	for i in player.get_children():
		if i is Camera2D:
			cam = i
			break
	if not cam:
		print("COULD NOT FIND PLAYER CAM")
	
	if direction == DIRECTION.RIGHT:
		edge = cam.limit_left
		player.position = Vector2(edge + WIDTH_OFFSET, base - HEIGHT_OFFSET)
	elif direction == DIRECTION.LEFT:
		edge = cam.limit_right
		player.position = Vector2(edge - WIDTH_OFFSET, base - HEIGHT_OFFSET)
	elif direction == DIRECTION.DOWN:
		edge = cam.limit_bottom
		player.position = Vector2(base + 100, edge - HEIGHT_OFFSET)
	elif direction == DIRECTION.UP:
		edge = cam.limit_top
		player.position = Vector2(base + 100, edge + HEIGHT_OFFSET)
		player.momentumVel += Vector2(0, -700) # big jump

	teleported = true

func teleportToStart():
	teleport(0, startTeleportBase, startTeleportExitDirection)

var atEnd = false
func teleportToEnd():
	if endTeleportEnterDirection == DIRECTION.DOWN: endTeleportEnterDirection = DIRECTION.UP
	elif endTeleportEnterDirection == DIRECTION.UP: endTeleportEnterDirection = DIRECTION.DOWN
	elif endTeleportEnterDirection == DIRECTION.LEFT: endTeleportEnterDirection = DIRECTION.RIGHT
	elif endTeleportEnterDirection == DIRECTION.RIGHT: endTeleportEnterDirection = DIRECTION.LEFT
	teleport(0, endTeleportBase, endTeleportEnterDirection)
	atEnd = true

func switch(poof=true):
	fireScene = not fireScene
	Global.isFireScene = fireScene
	for i in get_children():
		if i is TileMap:
			i.switch(fireScene, poof)

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	if theme == MUSIC.MAIN:
		music.playMain()
	elif theme == MUSIC.BOSS:
		music.playBoss()
	
	if forceDimension or not Global.isFireScene is bool:
		fireScene = not fireScene
	else:
		fireScene = not Global.isFireScene
	
	switch(false)
	
	if not teleported:
		if atEnd:
			teleportToEnd()
		else:
			player.position = playerStart
	
	for i in player.get_children():
		if i is Camera2D:
			i.queue_free()
	$Camera2D.reparent(player, false)

func _process(delta):
	if Input.is_action_just_pressed("switch_dimension") and not player.dead:
		switch()
