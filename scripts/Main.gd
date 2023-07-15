extends Node2D

const screens = ["res://screens/Screen1.tscn"]

var currentScreen

func loadScreen(id):
	if currentScreen == id: return
	
	currentScreen = id
	var screenLoad = load(screens[id])
	for c in get_children():
		if c != $PlayerNode:
			c.queue_free()
	add_child(screenLoad.instantiate())

func _ready():
	loadScreen(0)

func _process(delta):
	pass
