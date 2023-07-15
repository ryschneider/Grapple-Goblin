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

	if staticCamera == true:
		print(get_children())
		#$Camera2D.position
#	cameraController(0)
