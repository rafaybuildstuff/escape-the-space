extends Area2D

@export_file("*.tscn") var target_scene: String = "res://Scenes/end.tscn"

var player_in_range: bool = false
var is_fixed: bool = false

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)
	if not is_connected("body_exited", _on_body_exited):
		body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_range = true
		print("Player is near the rocket. Press 'F' to fix!")

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_range = false

func _input(event: InputEvent) -> void:
	# Check if player is nearby, presses "F", and all parts are collected
	if player_in_range and not is_fixed and Input.is_key_pressed(KEY_F):
		
		# Optional: Check if player has all 4 parts before fixing
		if Global.has_all_parts():
			is_fixed = true
			print("Rocket is being fixed! Transitioning in 1 second...")
			
			# Optional fade effect if you have a CanvasLayer/ColorRect
			var color_rect = get_tree().current_scene.get_node_or_null("CanvasLayer/ColorRect")
			if color_rect and color_rect.has_method("fade_out"):
				color_rect.fade_out()
			
			# Wait for 1 second as requested
			await get_tree().create_timer(1.0).timeout
			
			# Change scene to end.tscn
			if target_scene != "":
				get_tree().change_scene_to_file(target_scene)
		else:
			print("You need all parts to fix the rocket! Collected: ", Global.total_parts_collected, "/", Global.max_parts)
