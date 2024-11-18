extends Node2D

@onready var tile_map = $TileMapLayer
@export var noise_height_text: NoiseTexture2D

var noise: Noise

var width: int = 200
var height: int = width

var land_source = 0
var land_atlas = Vector2i(2, 6)
var water_source = 1
var water_atlas = Vector2i(9, 7)

func _ready():
	noise = noise_height_text.noise
	generate_world()


func generate_world():
	for x in range(width):
		for y in range(height):
			var noise_val = noise.get_noise_2d(x, y)
			if noise_val > 0.0:
				tile_map.set_cell(Vector2(x, y), land_source, land_atlas)
			elif noise_val < 0.0:
				tile_map.set_cell(Vector2(x, y), water_source, water_atlas)
				pass
