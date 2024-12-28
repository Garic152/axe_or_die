extends CharacterBody2D

signal HealthChanged

@export var speed: int = 35
@export var maxHealth = 3

@onready var animation = $AnimationPlayer
@onready var effects = $Effects
@onready var sprite = $Sprite2D
@onready var axe = preload("res://Scenes/weapons/axe.tscn")

var current_health: int = maxHealth
var isHurt: bool = false


func _ready() -> void:
	effects.play("RESET")


func throw_axe() -> void:
	# get throw coordinations
	var mouse_pos = get_global_mouse_position()
	var throw_direction = (mouse_pos - self.global_position).normalized()
	
	# spawn axe
	var axe_inst = axe.instantiate()
	axe_inst.global_position += throw_direction * 20
	
	# apply physics
	axe_inst.apply_central_impulse(throw_direction * 200)
	var torque = 2000 if throw_direction.x >= 0 else -2000
	axe_inst.apply_torque(torque)
	
	add_child(axe_inst)


func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	
	if Input.is_action_just_pressed("attack"):
		throw_axe()

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
	
	if area.get_parent().is_in_group("enemy"):
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
