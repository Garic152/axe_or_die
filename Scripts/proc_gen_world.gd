extends Node2D

@onready var water_layer = $Water
@onready var ground_layer = $Ground
@onready var grass_layer = $Grass
@onready var cliff_layer = $Cliffs
@onready var props_layer = $Props

@export var noise_height_text: NoiseTexture2D
@export var noise_tree_text: NoiseTexture2D
var noise: Noise
var tree_noise: Noise

var width: int = 50
var height: int = width

var source_id = 0
var land_atlas = Vector2i(2, 6)
var water_atlas = Vector2i(4, 7)

var palm_tree_atlas_arr = [Vector2i(1, 1), Vector2i(6, 1)]
var ground_tiles_arr = []


func _ready():
	noise = noise_height_text.noise
	tree_noise = noise_tree_text.noise
	generate_world()

func choose_vector():
	var rand = randf()
	if rand < 0.2:
		return Vector2i(randi_range(10, 11), randi_range(1, 4))
	return Vector2i(2, 2)

func generate_world():
	for x in range(width):
		for y in range(height):
			var noise_val = noise.get_noise_2d(x, y)
			var tree_noise_val = tree_noise.get_noise_2d(x, y)
			if noise_val > 0.25:
				ground_tiles_arr.append(Vector2i(x, y))
				if noise_val > 0.35:
					grass_layer.set_cell(Vector2i(x, y), source_id, choose_vector())
					if tree_noise_val > 0.4:
						props_layer.set_cell(Vector2i(x, y), 1, palm_tree_atlas_arr.pick_random())
			water_layer.set_cell(Vector2(x, y), source_id, water_atlas)

	ground_layer.set_cells_terrain_connect(ground_tiles_arr, 1, 0)
