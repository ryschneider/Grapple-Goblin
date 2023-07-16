extends Node2D

const NUM_SCREENS = 21
var screens = ["res://screens/Template.tscn"]

func _ready():
	$PauseMenu.hide()
	$Player/SFX.playButton()
	
	for i in range(NUM_SCREENS):
		screens.push_back("res://screens/Screen" + str(i+1) + ".tscn")
	
	if Global.continueSave:
		loadSave()
	else:
		newGame()
#	loadScreen(3)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		
		if get_tree().paused:
			for i in $Player.get_children():
				if i is Camera2D:
					$PauseMenu.position = i.get_screen_center_position()
					break
			$PauseMenu.show()
		else:
			$PauseMenu.hide()

func unpause():
	get_tree().paused = false
	$PauseMenu.hide()

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
	FileAccess.open("user://cangrapple.txt", FileAccess.WRITE).store_string("no")
	loadScreen(1) # eg. 7 for Screen7.tscn


func restartScreen():
	var atEnd = get_children()[get_child_count() - 1].atEnd
	get_children()[get_child_count() - 1].queue_free()
	var sc = currentScreenLoad.instantiate()
	sc.atEnd = atEnd
	add_child(sc)

func loadScreen(id):
#	id += 1
	if currentScreen == id: return
	
	currentScreen = id
	currentScreenLoad = load(screens[id])
	for c in get_children():
		if c.has_method("teleportToStart"): # if is scene
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
