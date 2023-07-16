extends Control

func _on_back_pressed():
	get_tree().change_scene_to_file("res://objects/Menu.tscn")

func _process(delta):
	for i in range($MarginContainer/VBoxContainer/GridContainer.get_child_count()):
		var button = $MarginContainer/VBoxContainer/GridContainer.get_children()[i]
		if button.button_pressed:
			Global.continueSave = true
			var save = FileAccess.open("user://save.txt", FileAccess.WRITE)
			save.store_string(str(i+1))
			await get_tree().process_frame
			
			get_tree().change_scene_to_file("res://objects/Main.tscn")
			return
