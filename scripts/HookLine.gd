extends Line2D

@onready var Player = get_node("../Player")
@onready var Hook = get_node("../Hook")

func _process(_delta):
	clear_points()
	if Hook.is_visible():
		add_point(Hook.global_position)
		add_point(Player.global_position)
