extends CharacterBody2D

signal HealthChanged

@export var speed: int = 55
@export var maxHealth = 10

@onready var hearts_container = $CanvasLayer/heartsContainer
@onready var animation = $AnimationPlayer
@onready var effects = $Effects
@onready var sprite = $Sprite2D
@onready var axe = preload("res://Scenes/weapons/axe.tscn")
@onready var attack_cooldown = $attack_cooldown
@onready var is_hurt = $hurt
@onready var hurtbox = $hurtbox
@onready var collision = $CollisionShape2D

@onready var main_music = $music
@onready var gameover_sound = $gameover
@onready var hurt_sound = $hurt2
@onready var death_loop = $CanvasLayer/DeathAnimation
@onready var kill_count = $CanvasLayer/Counter
@onready var death_message = $CanvasLayer/death

@onready var current_health: int = maxHealth
var alive = true


func _ready() -> void:
	hearts_container.setMaxHearts(maxHealth)
	HealthChanged.connect(hearts_container.updateHearts)
	effects.play("RESET")


func throw_axe() -> void:
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


func handleInput():
	if alive:
		var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = moveDirection * speed
	else:
		velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("attack") && attack_cooldown.is_stopped():
		throw_axe()
		attack_cooldown.start()

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
		hurt_sound.play()
		current_health -= 1
		HealthChanged.emit(current_health)
		knockback(area.global_position)
		effects.play("hurt_blink")
	if current_health <= 0:
		alive = false
		self.visible = false
		hurtbox.queue_free()
		collision.queue_free()
		
		main_music.stop()
		gameover_sound.play()
		death_loop.play("death")
		
		var kills = int(kill_count.text.split(": ")[1])
		
		death_message.text = ("You Died \n Kills: " + str(kills))
		
		
		



func knockback(source: Vector2):
	velocity = (global_position - source).normalized() * 1000
	move_and_slide()
