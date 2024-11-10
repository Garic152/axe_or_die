extends CharacterBody2D

@export var speed: int = 35
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D


func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed


func updateAnimation():
	if velocity.length() != 0:
		if velocity.x < 0: sprite.flip_h = true
		elif velocity.x > 0: sprite.flip_h = false
		animation.play("walk")
	else:
		animation.play("idle")


func handleCollison():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

func _physics_process(delta: float) -> void:
	handleInput()
	move_and_slide()
	handleCollison()
	updateAnimation()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "hitbox":
		print_debug(area.name)
