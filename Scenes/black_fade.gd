extends ColorRect

func start_transition(bg_nodes: Array) -> void:
	var tween = create_tween()
	
	# 1. Fade screen to solid black over 1 second
	tween.tween_property(self, "color", Color(0, 0, 0, 1.0), 1.0)
	
	# 2. While screen is solid black, change background colors to Red!
	tween.tween_callback(func():
		for bg in bg_nodes:
			if bg:
				bg.modulate = Color(1.0, 0.2, 0.2, 1.0)
	)
	
	# 3. Fade black screen back out to transparent over 1 second
	tween.tween_property(self, "color", Color(0, 0, 0, 0.0), 1.0)
