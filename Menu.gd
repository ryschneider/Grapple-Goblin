extends Control

func _ready():
	if not Global.firstMainMenu:
		$ButtonSound.play()
	Global.firstMainMenu = false
	Global.canGrapple = false
	
	if FileAccess.file_exists("user://save.txt"):
		$MarginContainer/VBoxContainer/Continue.show()
		$MarginContainer/VBoxContainer/Play.show()
		$MarginContainer/VBoxContainer/Play.custom_minimum_size.y = 150
		$MarginContainer/VBoxContainer/Play.text = "New Game"
	else:
		$MarginContainer/VBoxContainer/Continue.hide()
		$MarginContainer/VBoxContainer/Play.custom_minimum_size.y = 300
		$MarginContainer/VBoxContainer/Play.text = "New Game"
	
	if FileAccess.file_exists("user://showlevels.txt"):
		$MarginContainer/VBoxContainer/LevelSelect.show()
	else:
		$MarginContainer/VBoxContainer/LevelSelect.hide()
	
	if FileAccess.file_exists("user://beatgame.txt"):
		$winner/goblin.show()
		$winner/goblin/Crown.show()
		$loser/Goblinjump.hide()
	else:
		$loser/Goblinjump.show()
		$winner/goblin.hide()
		$winner/goblin/Crown.hide()

func _process(delta):
	if Input.is_action_just_pressed("levelselect"):
		$MarginContainer/VBoxContainer/LevelSelect.show()

func _on_play_pressed():
	Global.continueSave = false
	get_tree().change_scene_to_file("res://objects/Main.tscn")

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://objects/level_select.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_continue_pressed():
	Global.continueSave = true
	get_tree().change_scene_to_file("res://objects/Main.tscn")
