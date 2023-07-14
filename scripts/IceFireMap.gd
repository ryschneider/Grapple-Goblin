extends TileMap

const FIRE_SOURCE = 0
const ICE_SOURCE = 1

const FIRE_TERRAIN = 0
const ICE_TERRAIN = 1

var fireScene = true
var hiddenTiles = []

@onready var Player = get_node("../PlayerNode")

func switch():
	fireScene = not fireScene
	if fireScene:
		# show fire tiles
		set_cells_terrain_connect(0, hiddenTiles, 0, FIRE_TERRAIN)
		
		# hide ice tiles
		hiddenTiles = get_used_cells_by_id(0, ICE_SOURCE)
		set_cells_terrain_connect(0, hiddenTiles, 0, -1)
	else:
		# show fire tiles
		set_cells_terrain_connect(0, hiddenTiles, 0, ICE_TERRAIN)
		
		# hide ice tiles
		hiddenTiles = get_used_cells_by_id(0, FIRE_SOURCE)
		set_cells_terrain_connect(0, hiddenTiles, 0, -1)

func _ready():
	switch()

func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		switch()
