extends CharacterBody2D

signal HealthChanged

@export var speed: int = 35
@export var maxHealth = 3

@onready var animation = $AnimationPlayer
@onready var effects = $Effects
@onready var sprite = $Sprite2D
@onready var axe = preload("res://Scenes/weapons/axe.tscn")
@onready var attack_cooldown = $attack_cooldown
@onready var is_hurt = $hurt

var current_health: int = maxHealth


func _ready() -> void:
	effects.play("RESET")


func throw_axe() -> void:
	if attack_cooldown.is_stopped():
		# get throw coordinations
		var mouse_pos = get_global_mouse_position()
		var throw_direction = (mouse_pos - self.global_position).normalized()
		
		# spawn axe
		var axe_inst = axe.instantiate()
		axe_inst.global_position += throw_direction * 10
		
		# apply physics
		axe_inst.apply_central_impulse(throw_direction * 200)
		var torque = 6000 if throw_direction.x >= 0 else -6000
		if throw_direction.x < 0:
			axe_inst.get_child(0).flip_h = true
		axe_inst.apply_torque(torque)
		
		add_child(axe_inst)
		
		attack_cooldown.start()


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
	var collision_count = get_slide_collision_count()
	if collision_count == 0:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()


func _physics_process(delta: float) -> void:
	handleInput()
	move_and_slide()
	handleCollison()
	updateAnimation()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if is_hurt.is_stopped() == false: return
	
	if area.get_parent().is_in_group("enemy"):
		is_hurt.start()
		current_health -= 1
		HealthChanged.emit(current_health)
		knockback(area.global_position)
		effects.play("hurt_blink")
	if current_health <= 0:
		queue_free()


func knockback(source: Vector2):
	velocity = (global_position - source).normalized() * 300
	move_and_slide()
