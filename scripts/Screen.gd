extends Node2D

@onready var player = get_node("../Player")
@onready var screenNode = get_node(".")

@export var fireScene = false
@export var staticCamera = false
@export var playerStart = Vector2()
@export var teleportStart = Vector2()
@export var teleportEnd = Vector2()

var teleported = false

func teleportToStart():
	player.position = teleportStart
	teleported = true

func teleportToEnd():
	player.position = teleportEnd
	teleported = true

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
