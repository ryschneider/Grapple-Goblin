extends Node2D

const NUM_SCREENS = 21
var screens = ["res://screens/Template.tscn"]
func _ready():
	for i in range(NUM_SCREENS):
		screens.push_back("res://screens/Screen" + str(i+1) + ".tscn")
	
	loadSave()
#	loadScreen(4)

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
	if currentScreen > 1:
		loadScreen(currentScreen - 1)

func nextScreen():
	if currentScreen < NUM_SCREENS:
		loadScreen(currentScreen + 1)
