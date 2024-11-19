extends Node2D

@onready var water_layer = $Water
@onready var ground_layer= $Ground
@onready var cliff_layer = $Cliffs
@onready var props_layer = $Props

@export var noise_height_text: NoiseTexture2D

var noise: Noise

var width: int = 200
var height: int = width

var source_id = 0
var land_atlas = Vector2i(2, 6)
var water_atlas = Vector2i(4, 7)

var ground_tiles_arr = []


func _ready():
	noise = noise_height_text.noise
	generate_world()


func generate_world():
	for x in range(width):
		for y in range(height):
			var noise_val = noise.get_noise_2d(x, y)
			if noise_val > 0.0:
				ground_tiles_arr.append(Vector2i(x, y))
			water_layer.set_cell(Vector2(x, y), source_id, water_atlas)

	ground_layer.set_cells_terrain_connect(ground_tiles_arr, 1, 0)
