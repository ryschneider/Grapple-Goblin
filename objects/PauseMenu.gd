extends Control


func _on_continue_pressed():
	get_parent().unpause()

func _on_settings_pressed():
	pass # Replace with function body.

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://objects/Menu.tscn")
