extends Node2D

const NUM_SCREENS = 21
var screens = ["res://screens/Template.tscn"]
func _ready():
	for i in range(NUM_SCREENS):
		screens.push_back("res://screens/Screen" + str(i+1) + ".tscn")
	
	loadScreen(15) # eg. 7 for Screen7.tscn

var currentScreen
var currentScreenLoad

func restartScreen():
	get_children()[get_child_count() - 1].queue_free()
	add_child(currentScreenLoad.instantiate())
	
#	for i in get_children():
#		i.reload_current_scene()
#	$Screen.reload_current_scene()
#	$Player.reload_current_scene()
#	$Player.reload_current_scene()

func loadScreen(id):
#	id -= 1
	if currentScreen == id: return
	
	currentScreen = id
	currentScreenLoad = load(screens[id])
	for c in get_children():
		if c != $Player and c != $Hook and c != $HookLine:
			c.queue_free()
	add_child(currentScreenLoad.instantiate())

func prevScreen():
	if currentScreen > 1:
		loadScreen(currentScreen - 1)

func nextScreen():
	if currentScreen < NUM_SCREENS:
		loadScreen(currentScreen + 1)
