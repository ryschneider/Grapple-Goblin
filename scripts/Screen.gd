extends Node2D

var fireScene = false
@onready var player = get_node("../Player")
@onready var screenNode = get_node(".")

@export var staticCamera = false
@export var playerStart = Vector2()

func switch(poof=true):
	fireScene = not fireScene
	for i in get_children():
		if i is TileMap:
			i.switch(fireScene, poof)
	$Background.switch(fireScene)

func _ready():
	switch(false)
	player.position = playerStart
	$Camera2D.reparent(player, false)

func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		switch()
#	cameraController(0)

#func cameraController(followLineX):
#	if $Camera2D.position.x > followLineX && staticCamera == false:
#
#	else:
#		$Camera2D.reparent(screenNode,false)
#		$Camera2D.position = Vector2(0, 0)
#
