extends Camera2D

@export var tilemap: TileMapLayer

func _ready() -> void:
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.rendering_quadrant_size
	var worldSize = mapRect.size * tileSize
	
	limit_left = 0
	limit_top = 0
	limit_right = worldSize.x
	limit_bottom = worldSize.y
