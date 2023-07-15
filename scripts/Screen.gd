extends Node2D

@onready var player = get_node("../Player")
@onready var screenNode = get_node(".")

@export var fireScene = false
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
		edge = cam.limit_up
		player.position = Vector2(base + 100, edge - HEIGHT_OFFSET)
	elif direction == DIRECTION.UP:
		edge = cam.limit_down
		player.position = Vector2(base + 100, edge + HEIGHT_OFFSET)
		player.momentumVel += Vector2(0, -700) # big jump
	teleported = true

func teleportToStart():
	teleport(0, startTeleportBase, startTeleportExitDirection)

func teleportToEnd():
	if endTeleportEnterDirection == DIRECTION.DOWN: endTeleportEnterDirection = DIRECTION.UP
	if endTeleportEnterDirection == DIRECTION.UP: endTeleportEnterDirection = DIRECTION.DOWN
	if endTeleportEnterDirection == DIRECTION.LEFT: endTeleportEnterDirection = DIRECTION.RIGHT
	if endTeleportEnterDirection == DIRECTION.RIGHT: endTeleportEnterDirection = DIRECTION.LEFT
	teleport(0, endTeleportBase, endTeleportEnterDirection)

func switch(poof=true):
	fireScene = not fireScene
	Global.isFireScene = fireScene
	for i in get_children():
		if i is TileMap:
			i.switch(fireScene, poof)

func _ready():
	fireScene = not fireScene
	
	switch(false)
	
	if not teleported: player.position = playerStart
	for i in player.get_children():
		if i is Camera2D:
			i.queue_free()
	$Camera2D.reparent(player, false)

func _process(delta):
	if Input.is_action_just_pressed("switch_dimension") and not player.dead:
		switch()
