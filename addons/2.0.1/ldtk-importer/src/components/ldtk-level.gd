@icon("ldtk-level.svg")
@tool
class_name LDTKLevel
extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $Player

@export var iid: String
@export var world_position: Vector2
@export var size: Vector2i
@export var fields: Dictionary
@export var neighbours: Array
@export var bg_color: Color

func _ready() -> void:
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
	queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO, size), bg_color, false, 2.0)
