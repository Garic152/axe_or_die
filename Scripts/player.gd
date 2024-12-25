extends CharacterBody2D

signal HealthChanged

@export var speed: int = 35
@export var maxHealth = 3

@onready var animation = $AnimationPlayer
@onready var effects = $Effects
@onready var sprite = $Sprite2D

var current_health: int = maxHealth
var isHurt: bool = false


func _ready() -> void:
	effects.play("RESET")


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
	if isHurt: return
	
	if area.name == "hitbox":
		isHurt = true
		current_health -= 1
		HealthChanged.emit(current_health)
		knockback(area.global_position)
		effects.play("hurt_blink")
	if current_health <= 0:
		queue_free()
	isHurt = false


func knockback(source: Vector2):
	velocity = (global_position - source).normalized() * 500
	move_and_slide()
