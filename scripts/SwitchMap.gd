extends TileMap

func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		var s0 = get_used_cells_by_id(0, 0)
		var s1 = get_used_cells_by_id(0, 1)
		
		for xy in s0:
			var at = get_cell_atlas_coords(0, xy)
			set_cell(0, xy, 1, at)
		for xy in s1:
			var at = get_cell_atlas_coords(0, xy)
			set_cell(0, xy, 0, at)
