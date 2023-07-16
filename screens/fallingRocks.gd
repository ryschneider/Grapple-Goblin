extends Node2D

var left = 0 
var right = 11000
var lastRockTime = 0
var newRockTime = 0.05
var rock = preload("res://objects/Fallingrock.tscn")

#@onready var rock = get_node("../rock")

func _ready():
	return
	
func _physics_process(delta):
	if (delta + lastRockTime) > newRockTime:
		lastRockTime = 0
		var sprite2d = rock.instantiate() # Create a new Sprite2D.
		add_child(sprite2d) # Add it as a child of this node.
		sprite2d.position.y = -300
		sprite2d.position.x = randf_range(left,right)

	else:
		lastRockTime = lastRockTime + delta		
