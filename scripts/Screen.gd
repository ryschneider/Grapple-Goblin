extends Node2D

var fireScene = false

func switch(poof=true):
	fireScene = not fireScene
	for i in get_children():
		if i is TileMap:
			i.switch(fireScene, poof)
	$Background.switch(fireScene)

func _ready():
	switch(false)

func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		switch()
