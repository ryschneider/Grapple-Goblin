extends TileMap

const FIRE_TERRAIN = 0
const ICE_TERRAIN = 1

const FIRE_SOURCES = [0]
const ICE_SOURCES = [1]

# 5,6 decorations, 8,9 bg
const FLIP_PAIRS = [Vector2i(5, 6), Vector2i(8, 9)]

var fireScene = true
var hiddenTiles = []

@onready var Player = get_node("../PlayerNode")

func switch():
	fireScene = not fireScene
	
	# toggle layer 0 tiles
	var showTerrain
	var hideSources
	if fireScene:
		showTerrain = FIRE_TERRAIN
		hideSources = ICE_SOURCES
	else:
		showTerrain = ICE_TERRAIN
		hideSources = FIRE_SOURCES
	
	set_cells_terrain_connect(0, hiddenTiles, 0, showTerrain)
	hiddenTiles = []
	for source in hideSources:
		hiddenTiles += get_used_cells_by_id(0, source)
	set_cells_terrain_connect(0, hiddenTiles, 0, -1)
	
	# flip layer 1 tiles
	for i in FLIP_PAIRS:
		var from
		var to
		if fireScene:
			from = i.y
			to = i.x
		else:
			from = i.x
			to = i.y
		
		for xy in get_used_cells_by_id(1, from):
			set_cell(1, xy, to, get_cell_atlas_coords(1, xy))

func _ready():
	switch()

func _process(delta):
	if Input.is_action_just_pressed("switch_dimension"):
		switch()
