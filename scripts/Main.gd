extends Node2D

const NUM_SCREENS = 21
var screens = ["res://screens/Template.tscn"]
func _ready():
	for i in range(NUM_SCREENS):
		screens.push_back("res://screens/Screen" + str(i+1) + ".tscn")
	
	loadScreen(14) # eg. 7 for Screen7.tscn

var currentScreen

func loadScreen(id):
#	id -= 1
	if currentScreen == id: return
	
	currentScreen = id
	var screenLoad = load(screens[id])
	for c in get_children():
		if c != $Player and c != $Hook and c != $HookLine:
			c.queue_free()
	add_child(screenLoad.instantiate())

func prevScreen():
	print("prev")

func nextScreen():
	print("next")

