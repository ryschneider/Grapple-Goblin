extends TileMap

const FIRE_TERRAIN = 0
const ICE_TERRAIN = 1

const FIRE_SOURCES = [0, 4, 7]
const ICE_SOURCES = [1, 5, 8]

# 4,5 decorations, 7,8 hazards
const FLIP_PAIRS = [Vector2i(0, 1), Vector2i(4, 5), Vector2i(7, 8)]

var hiddenTiles = []

@onready var Player = get_node("../../Player")
@onready var Snowflake = load("res://resources/Snowflake.tscn")
@onready var Ember = load("res://resources/Ember.tscn")

class Cell:
	var xy: Vector2i
	var atlasXY: Vector2i
	var alt: int
	var source: int
	var terrain: int

func switch(fireScene, poof = true):
	# toggle layer 0 tiles
	var showTerrain
	var showSources
	var hideSources
	if fireScene:
		showTerrain = FIRE_TERRAIN
		showSources = FIRE_SOURCES
		hideSources = ICE_SOURCES
	else:
		showTerrain = ICE_TERRAIN
		showSources = ICE_SOURCES
		hideSources = FIRE_SOURCES
	
	for cell in hiddenTiles:
		set_cell(0, cell.xy, cell.source, cell.atlasXY, cell.alt)
	hiddenTiles = []
	for source in hideSources:
		for xy in get_used_cells_by_id(0, source):
			var cell = Cell.new()
			cell.xy = xy
			cell.atlasXY = get_cell_atlas_coords(0, xy)
			cell.alt = get_cell_alternative_tile(0, xy)
			cell.source = source
			erase_cell(0, xy)
			hiddenTiles.push_back(cell)
			
			if poof and (source == 0 || source == 1): # only poof platforms
				var particle
				if fireScene:
					particle = Snowflake.instantiate()
				else:
					particle = Ember.instantiate()
				particle.position = cell.xy * 16
				add_child(particle)
	
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
			set_cell(1, xy, to, get_cell_atlas_coords(1, xy), get_cell_alternative_tile(1, xy))
