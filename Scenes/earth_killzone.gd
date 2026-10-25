extends Area2D

@export var restart_delay: float = 1.0 # Match or exceed your audio/wait time

func _ready() -> void:
	# Make sure the signal is connected (if not already connected in the editor)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	# Check if the body that fell into the killzone is the player
	if body is CharacterBody2D:
		print("Player fell down!")
		
		# Check if the player has our die() function
		if body.has_method("die"):
			body.die() # This handles freezing, hiding, and playing the audio!
		else:
			# Fallback if die() isn't found
			body.set_physics_process(false)
			await get_tree().create_timer(restart_delay).timeout
			get_tree().reload_current_scene()
