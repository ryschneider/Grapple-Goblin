extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Bg.show()
	$First.hide()
	$Second.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = -8
const STAGE_2 = 2
const PROD_DELAY = 2
const STAGE_3 = STAGE_2 + 5
const STAGE_4 = STAGE_3 + 5
const STAGE_5 = STAGE_4 + 5
func _process(delta):
	time += delta
	
	if time < 0:
		$Bg.show()
		$First.hide()
		$Second.hide()
	elif time < STAGE_2:
		$Bg.hide()
		$First.hide()
		$Second.hide()
	elif time < STAGE_3:
		$First.show()
		$First/mouse.show()
		
		$First/production.show()
		$First/production.modulate[3] = (time - STAGE_2 - PROD_DELAY) / (STAGE_3-STAGE_2 - PROD_DELAY)
		
		$First/names.hide()
	elif time < STAGE_4:
		$First/names.show()
	elif time < STAGE_5:
		$First.hide()
		$Second.show()
	else:
		FileAccess.open("user://beatgame.txt", FileAccess.WRITE).store_string("yes")
		FileAccess.open("user://showlevels.txt", FileAccess.WRITE).store_string("yes")
		get_tree().change_scene_to_file("res://objects/Menu.tscn")
