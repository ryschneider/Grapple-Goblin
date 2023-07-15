extends Node2D

var fireScene = false
@onready var player = get_node("../Player")
@onready var screenNode = get_node(".")
@export var staticCamera = false
@export var staringPos = Vector2(-550, 250)

func switch(poof=true):
	fireScene = not fireScene
	for i in get_children():
		if i is TileMap:
			i.switch(fireScene, poof)
	$Background.switch(fireScene)

func _ready():
	switch(false)
	player.position = staringPos


func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		switch()

	if staticCamera == true:
		print(get_children())
		#$Camera2D.position
#	cameraController(0)
