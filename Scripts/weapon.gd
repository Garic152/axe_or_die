extends Area2D

@export var damage: int = 1
@export var knockback: int = 5


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy"):
		self.queue_free()


func _on_timer_timeout() -> void:
	self.get_parent().queue_free()
