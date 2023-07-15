extends Node2D

func _ready():
	for i in get_children():
		if i is TileMap:
			i.switch(false)

func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		for i in get_children():
			if i is TileMap:
				i.switch()
