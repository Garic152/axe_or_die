extends CharacterBody2D

class_name Player

@export var speed: int = 35
@export var maxHealth = 3

@onready var animation = $AnimationPlayer
@onready var effects = $Effects
@onready var sprite = $Sprite2D
@onready var health = $Health


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
	if health.isHurt: return
	
	if area.name == "hitbox":
		health.isHurt = true
		health.currentHealth -= 1
		health.healthChanged.emit(current_health)
		knockback(area.position)
		effects.play("hurt_blink")
	if health.currentHealth <= 0:
		sprite.visible = false
	health.isHurt = false


func knockback(source: Vector2):
	velocity = (source - position).normalized() * 500
	move_and_slide()
