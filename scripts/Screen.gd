extends Node2D

var fireScene = false
@onready var player = get_node("../PlayerNode")
@onready var screenNode = get_node(".")
@export var staticCamera = false

func switch(poof=true):
	fireScene = not fireScene
	for i in get_children():
		if i is TileMap:
			i.switch(fireScene, poof)
	$Background.switch(fireScene)

func _ready():
	switch(false)
	player.position = Vector2(-550, 250)


func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		switch()
<<<<<<< HEAD
	cameraController(0)

func cameraController(followLineX):
	if $Camera2D.position.x > followLineX && staticCamera == false:
		$Camera2D.reparent(player,false)
	else:
		$Camera2D.reparent(screenNode,false)
		$Camera2D.position = Vector2(0, 0)
=======
	if staticCamera == true:
		print(get_children())
		#$Camera2D.position
#	cameraController(0)
>>>>>>> d783519a93f63369a9c7f84646f018c0f6d365eb

