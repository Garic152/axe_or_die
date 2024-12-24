extends Panel

@onready var sprite = $Sprite2D


func update(whole: bool):
	if whole: sprite.visible = true
	else: sprite.visible = false
