extends Area2D

@export var restart_delay: float = 0.5

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that fell into the killzone is the player
	if body is CharacterBody2D:
		print("Player fell down!")
		
		# Disable player movement immediately so they don't keep falling
		body.set_physics_process(false)
		
		# Wait for the restart delay without needing a Timer node
		await get_tree().create_timer(restart_delay).timeout
		
		# Reload current level
		get_tree().reload_current_scene()
