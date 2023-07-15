extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://objects/Main.tscn")

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://objects/level_select.tscn")

func _on_exit_pressed():
	get_tree().quit()
