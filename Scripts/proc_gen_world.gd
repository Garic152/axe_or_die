extends Node2D

@onready var hearts_container = $CanvasLayer/heartsContainer
@onready var water_layer = $Water
@onready var ground_layer = $Ground
@onready var grass_layer = $Grass
@onready var cliff_layer = $Cliffs
@onready var props_layer = $Props
@onready var player = $Player

@export var noise_height_text: NoiseTexture2D
@export var noise_tree_text: NoiseTexture2D
@export var noise_stone_text: NoiseTexture2D

var noise: Noise
var tree_noise: Noise
var stone_noise: Noise

var width: int = 100
var height: int = width

var source_id = 0
var land_atlas = Vector2i(2, 6)
var water_atlas = Vector2i(4, 7)

var tree_atlas_arr = [Vector2i(1, 1), Vector2i(6, 1)]
var stone_atlas_arr = [Vector2i(2, 3), Vector2i(4, 3), Vector2i(4, 4)]
var ground_tiles_arr = []

func _ready():
	noise = noise_height_text.noise
	tree_noise = noise_tree_text.noise
	stone_noise = noise_stone_text.noise
	generate_world()

func choose_grass():
	var rand = randf()
	if rand < 0.2:
		return Vector2i(randi_range(10, 11), randi_range(1, 4))
	return Vector2i(2, 2)

func choose_tree():
	var rand = randf()
	if rand < 0.1:
		return [Vector2i(1, 1), Vector2i(6, 1)].pick_random()
	return Vector2i(-1, -1)

func generate_world():
	for x in range(-10, width + 10):
		for y in range(-10, height + 10):
			water_layer.set_cell(Vector2(x, y), source_id, water_atlas)
			
	for x in range(width):
		for y in range(height):
			var noise_val = noise.get_noise_2d(x, y)
			if noise_val > 0.25:
				ground_tiles_arr.append(Vector2i(x, y))
		ground_layer.set_cells_terrain_connect(ground_tiles_arr, 1, 0)


	# Add vegetation
	for x in range(width):
		for y in range(height):
			if ground_layer.get_cell_atlas_coords(Vector2i(x, y)) == Vector2i(2, 6):
				var noise_val = noise.get_noise_2d(x, y)
				
				if noise_val > 0.3:
					grass_layer.set_cell(Vector2i(x, y), source_id, choose_grass())
					var tree_noise_val = tree_noise.get_noise_2d(x, y)
					var stone_noise_val = stone_noise.get_noise_2d(x, y)
					if tree_noise_val > 0.2:
						var tree = choose_tree()
						if tree != Vector2i(-1, -1):
							props_layer.set_cell(Vector2i(x, y), 1, tree_atlas_arr.pick_random())
					#if stone_noise_val > 0.45:
					#	props_layer.set_cell(Vector2i(x, y), 1, stone_atlas_arr.pick_random())
