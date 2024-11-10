extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export var speed: int

func follow_player(player: CharacterBody2D):
	var player_position = player.position
	var direction = (player_position - position).normalized()
	velocity = direction * speed


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
		follow_player(players[0])
	move_and_slide()
	updateAnimation()
