extends Node2D

const screens = ["res://screens/Screen1.tscn", "res://screens/Screen2.tscn", "res://screens/Screen3.tscn", "res://screens/Screen4.tscn", "res://screens/Screen5.tscn", "res://screens/Screen6.tscn", "res://screens/Screen7.tscn"]

var currentScreen

func loadScreen(id):
	if currentScreen == id: return
	
	currentScreen = id
	var screenLoad = load(screens[id])
	for c in get_children():
		if c != $Player and c != $Hook and c != $HookLine:
			c.queue_free()
	add_child(screenLoad.instantiate())

func _ready():
	loadScreen(5)

func _process(delta):
	pass
