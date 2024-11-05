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


func _physics_process(delta: float) -> void:
	handleInput()
	move_and_slide()
	updateAnimation()
