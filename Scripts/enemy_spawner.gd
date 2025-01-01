extends Node

@onready var zombie = preload("res://Scenes/EnemyGoblin.tscn")
@onready var slime = preload("res://Scenes/EnemySlime.tscn")
@onready var necromancer = preload("res://Scenes/EnemyNecromancer.tscn")
@onready var kill_sound = preload("res://sounds/kill.wav")

var ground_layer = TileMapLayer
var player = CharacterBody2D
var counter = RichTextLabel
var killed_enemies: int = 0

var spawn_timer = 0.4  # Seconds between spawns
var time_since_last_spawn = 0.0
var total_time = 0.0

var ground_border_arr = [Vector2i(-1, -1), Vector2i(1, 5), Vector2i(2, 5), Vector2i(3, 5), Vector2i(1, 6), Vector2i(3, 6), Vector2i(1, 7), Vector2i(2, 7), Vector2i(3, 7), Vector2i(1, 8), Vector2i(2, 8), Vector2i(3, 8), Vector2i(4, 5), Vector2i(5, 5), Vector2i(4, 6), Vector2i(5, 6)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_scene = get_tree().get_current_scene()
	if current_scene:
		if current_scene.has_node("Player"):
			player = current_scene.get_node("Player") as CharacterBody2D
		if current_scene.has_node("Ground"):
			ground_layer = current_scene.get_node("Ground") as TileMapLayer
		if current_scene.has_node("Player/CanvasLayer/Counter"):
			counter = current_scene.get_node("Player/CanvasLayer/Counter") as RichTextLabel
	else:
		print("rip: Current scene not found")
	
	


func _process(delta: float) -> void:
	time_since_last_spawn += delta
	total_time += delta

	if time_since_last_spawn >= spawn_timer:
		spawner()
		time_since_last_spawn = 0.0


func spawner() -> void:
	if total_time < 10:
		spawn_enemy(slime)
	elif total_time >= 10 and total_time < 20:
		var rand = randf()
		if rand < 0.2:
			spawn_enemy(zombie)
		else:
			spawn_enemy(slime)
	elif total_time >= 20 and total_time < 30:
		var rand = randf()
		if rand < 0.4:
			spawn_enemy(zombie)
		else:
			spawn_enemy(slime)
	elif total_time >= 30 and total_time < 40:
		var rand = randf()
		if rand < 0.6:
			spawn_enemy(zombie)
		else:
			spawn_enemy(slime)
	elif total_time >= 40 and total_time < 50:
		var rand = randf()
		if rand < 0.8:
			spawn_enemy(zombie)
		else:
			spawn_enemy(slime)
	elif total_time >= 50 and total_time < 60:
		var rand = randf()
		if rand < 0.2:
			spawn_enemy(necromancer)
		else:
			spawn_enemy(zombie)
	elif total_time >= 60 and total_time < 70:
		var rand = randf()
		if rand < 0.4:
			spawn_enemy(necromancer)
		else:
			spawn_enemy(zombie)
	elif total_time >= 70 and total_time < 80:
		var rand = randf()
		if rand < 0.6:
			spawn_enemy(necromancer)
		else:
			spawn_enemy(zombie)
	elif total_time >= 80 and total_time < 90:
		var rand = randf()
		if rand < 0.8:
			spawn_enemy(necromancer)
		else:
			spawn_enemy(zombie)
	elif total_time >= 90:
		spawn_enemy(necromancer)


func spawn_enemy(enemy: PackedScene):
		var x = randf_range(-1.0, 1.0)
		var y = randf_range(-1.0, 1.0)
		if x == 0 and y == 0:
			x = 1
			
		var direction = Vector2(x, y).normalized()
		
		var spawn_distance = randi_range(150, 250)
		var spawn_position = player.global_position + direction * spawn_distance
		
		var grid_position = ground_layer.local_to_map(spawn_position.round())
		if ground_layer.get_cell_atlas_coords(grid_position) == Vector2i(2, 6):
			var enemy_inst = enemy.instantiate()
			enemy_inst.global_position = spawn_position
			get_tree().current_scene.add_child(enemy_inst)
			if enemy_inst.has_signal("died"):
				enemy_inst.connect("died", Callable(self, "_on_enemy_died"))

func _on_enemy_died():
	killed_enemies += 1
	var audio_stream = AudioStreamPlayer.new()  # Create a temporary audio player
	audio_stream.stream = kill_sound           # Assign the preloaded sound
	audio_stream.volume_db = -2
	add_child(audio_stream)                    # Add it to the scene tree
	audio_stream.play()                        # Play the sound
	counter.text = "Kills: " + str(killed_enemies)
