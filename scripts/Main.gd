extends Node2D

const NUM_SCREENS = 21
var screens = ["res://screens/test.tscn"]
func _ready():
	for i in range(NUM_SCREENS):
		screens.push_back("res://screens/Screen" + str(i+1) + ".tscn")
	
	loadScreen(4) # eg. 7 for Screen7.tscn
	
var currentScreen
var currentScreenLoad

func restartScreen():
	get_children()[get_child_count() - 1].queue_free()
	add_child(currentScreenLoad.instantiate())

func loadScreen(id):
#	id -= 1
	if currentScreen == id: return
	
	currentScreen = id
	currentScreenLoad = load(screens[id])
	for c in get_children():
		if c != $Player and c != $Hook and c != $HookLine:
			c.queue_free()
#	add_child(currentScreenLoad.instantiate())
	call_deferred("add_child", currentScreenLoad.instantiate())

func prevScreen():
	if currentScreen > 1:
		loadScreen(currentScreen - 1)
		await get_tree().process_frame
		get_children()[get_child_count() - 1].teleportToEnd()

func nextScreen():
	if currentScreen < NUM_SCREENS:
		loadScreen(currentScreen + 1)
		await get_tree().process_frame
		get_children()[get_child_count() - 1].teleportToStart()
