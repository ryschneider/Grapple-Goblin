extends Node2D

const NUM_SCREENS = 21
var screens = ["res://screens/test.tscn"]

func _ready():
	for i in range(NUM_SCREENS):
		screens.push_back("res://screens/Screen" + str(i+1) + ".tscn")
	
	if Global.continueSave:
		loadSave()
	else:
		newGame()
#	loadScreen(1)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused

var currentScreen
var currentScreenLoad


func loadSave():
	if not FileAccess.file_exists("user://save.txt"):
		newGame()
		return
	
	var save = FileAccess.open("user://save.txt", FileAccess.READ)
	loadScreen(int(save.get_as_text()))

func saveGame():
	var save = FileAccess.open("user://save.txt", FileAccess.WRITE)
	save.store_string(str(currentScreen))
	print("Saving")

func newGame():
	loadScreen(12) # eg. 7 for Screen7.tscn


func restartScreen():
	var atEnd = get_children()[get_child_count() - 1].atEnd
	get_children()[get_child_count() - 1].queue_free()
	var sc = currentScreenLoad.instantiate()
	sc.atEnd = atEnd
	add_child(sc)

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
	
	saveGame()

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
