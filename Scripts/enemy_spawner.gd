extends Node

@onready var enemy = preload("res://Scenes/EnemyGoblin.tscn")

var ground_layer = TileMapLayer
var player = CharacterBody2D

var spawn_timer = 2.0  # Seconds between spawns
var time_since_last_spawn = 0.0

var ground_border_arr = [Vector2i(-1, -1), Vector2i(1, 5), Vector2i(2, 5), Vector2i(3, 5), Vector2i(1, 6), Vector2i(3, 6), Vector2i(1, 7), Vector2i(2, 7), Vector2i(3, 7), Vector2i(1, 8), Vector2i(2, 8), Vector2i(3, 8), Vector2i(4, 5), Vector2i(5, 5), Vector2i(4, 6), Vector2i(5, 6)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_scene = get_tree().get_current_scene()
	if current_scene and current_scene.has_node("Player") and current_scene.has_node("Ground"):
		player = current_scene.get_node("Player")
		ground_layer = current_scene.get_node("Ground")
	else:
		print(error_string(0))


func _process(delta: float) -> void:
	time_since_last_spawn += delta

	if time_since_last_spawn >= spawn_timer:
		spawn_enemy()
		time_since_last_spawn = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_enemy() -> void:
	var x = randf_range(-1.0, 1.0)
	var y = randf_range(-1.0, 1.0)
	if x == 0 and y == 0:
		x = 1
		
	var direction = Vector2(x, y).normalized()
	
	var spawn_distance = randi_range(100, 200)
	var spawn_position = player.global_position + direction * spawn_distance
	
	var grid_position = ground_layer.local_to_map(spawn_position.round())
	if ground_layer.get_cell_atlas_coords(grid_position) == Vector2i(2, 6):
		var enemy_inst = enemy.instantiate()
		enemy_inst.global_position = spawn_position
		get_tree().root.add_child(enemy_inst)