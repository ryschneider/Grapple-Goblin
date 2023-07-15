extends Node2D

var fireScene = false
@onready var player = get_node("../Player")
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
	cameraController(0)

func cameraController(followLineX):
	if player.position.x > followLineX && staticCamera == false:
		$Camera2D.position = player.position
		$Camera2D.position.y = $Camera2D.position.y - 250
	else:
		$Camera2D.position = Vector2(0, 0)

