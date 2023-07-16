extends Control

@onready var Music = get_node("../Player/Music")
@onready var SFX = get_node("../Player/SFX")

func _on_continue_pressed():
	SFX.playButton()
	get_parent().unpause()

func _on_settings_pressed():
	SFX.playButton()
	pass # Replace with function body.

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://objects/Menu.tscn")

func _ready():
	if not FileAccess.file_exists("user://audio.txt"):
		return
	var audio = FileAccess.open("user://audio.txt", FileAccess.READ).get_as_text()
	if audio == "off":
		Music.mute()

func _on_audio_button_toggled(audioOff):
	var file = FileAccess.open("user://audio.txt", FileAccess.WRITE)
	if audioOff:
		file.store_string("off")
		Music.mute()
	else:
		file.store_string("on")
		Music.unmute()
