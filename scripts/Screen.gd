extends Node2D

@onready var player = get_node("../Player")
@onready var screenNode = get_node(".")

@export var fireScene = false
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
	for i in player.get_children():
		if i is Camera2D:
			i.queue_free()
	$Camera2D.reparent(player, false)


func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		switch()
