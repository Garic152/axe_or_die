extends CharacterBody2D

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var context_rays_node = $ContextRays

@export var speed: int
@export var ray_length: int

var move_directions = [
	Vector2(1, 0).normalized(),          # 0 degrees
	Vector2(1, 0.5).normalized(),        # 22.5 degrees
	Vector2(1, 1).normalized(),          # 45 degrees
	Vector2(0.5, 1).normalized(),        # 67.5 degrees
	Vector2(0, 1).normalized(),          # 90 degrees
	Vector2(-0.5, 1).normalized(),       # 112.5 degrees
	Vector2(-1, 1).normalized(),         # 135 degrees
	Vector2(-1, 0.5).normalized(),       # 157.5 degrees
	Vector2(-1, 0).normalized(),         # 180 degrees
	Vector2(-1, -0.5).normalized(),      # 202.5 degrees
	Vector2(-1, -1).normalized(),        # 225 degrees
	Vector2(-0.5, -1).normalized(),      # 247.5 degrees
	Vector2(0, -1).normalized(),         # 270 degrees
	Vector2(0.5, -1).normalized(),       # 292.5 degrees
	Vector2(1, -1).normalized(),         # 315 degrees
	Vector2(1, -0.5).normalized()        # 337.5 degrees
]


var update_interval = 0.1
var time_accumulator = 0.0

func follow_player(player: CharacterBody2D):
	var player_position = player.global_position
	var player_direction = (player_position - global_position).normalized()
	
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.new()
	params.exclude = [self.get_rid()]
	params.collision_mask = 1 | 4
	
	var interest = PackedFloat32Array()
	var danger = PackedFloat32Array()
	var context_map = PackedFloat32Array()
	interest.resize(move_directions.size())
	danger.resize(move_directions.size())
	context_map.resize(move_directions.size())
	
	var best_index: int = 0
	var best_interest = -INF
	var penalty_big = 5
	var penalty_small = 2.5
	
	for i in range(move_directions.size()):
		interest[i] = player_direction.dot(move_directions[i])
		
		params.from = collision_shape.global_position
		params.to = params.from + move_directions[i] * ray_length
		
		var result = space_state.intersect_ray(params)
		if result:
			danger[i] += penalty_big
			var size = danger.size()
			danger[(i - 1) % size] += penalty_small
			danger[(i + 1) % size] += penalty_small
	
	for i in range(move_directions.size()):
		# Look for best interest
		context_map[i] = interest[i] - danger[i]
		if context_map[i] > best_interest:
			best_interest = context_map[i]
			best_index = i
			
	var best_direction = move_directions[best_index]
	velocity = best_direction * speed


func updateAnimation():
	if velocity.length() != 0:
		if velocity.x < 0: sprite.flip_h = true
		elif velocity.x > 0: sprite.flip_h = false
		sprite.play("run")
	else:
		sprite.play("idle")

func _physics_process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		time_accumulator += delta
		if time_accumulator >= update_interval:
			time_accumulator -= update_interval
			follow_player(players[0])
	move_and_slide()
	updateAnimation()
