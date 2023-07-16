extends Node2D

var left = -240 
var right = 1000
var lastRockTime = 0
var newRockTime = 10
var rock = preload("res://objects/Snowball.tscn")

#@onready var rock = get_node("../rock")

func _ready():
	return
	
func _physics_process(delta):
	if (delta + lastRockTime) > newRockTime:
		lastRockTime = 0
		var sprite2d = rock.instantiate() # Create a new Sprite2D.
		add_child(sprite2d) # Add it as a child of this node.
		sprite2d.position = Vector2(1156,208)
		var sprite2dd = rock.instantiate() # Create a new Sprite2D.
		add_child(sprite2dd) # Add it as a child of this node.
		sprite2dd.position = Vector2(0,-399)
		sprite2dd.constant_force.x = 300
		var sprite2ddd = rock.instantiate() # Create a new Sprite2D.
		add_child(sprite2ddd) # Add it as a child of this node.
		sprite2ddd.position = Vector2(1640,-802)
		sprite2ddd.constant_force.x = -300

	else:
		lastRockTime = lastRockTime + delta	
