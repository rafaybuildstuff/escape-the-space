extends ColorRect

func _ready() -> void:
	modulate.a = 0.0

func fade_out() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	await tween.finished
