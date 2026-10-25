extends Node2D

@onready var broadcast_banner = $BroadcastBanner

var waiting_for_next_level: bool = false

func _ready() -> void:
	# Connect to the banner's dismissed signal
	broadcast_banner.dismissed.connect(_on_banner_dismissed)

	# 1. Handle player spawning if arriving from another level
	if Global.next_spawn_portal != "":
		for node in get_children():
			var matches_name = node.name.to_lower() == Global.next_spawn_portal.to_lower()
			var matches_var = "current_portal_name" in node and node.current_portal_name.to_lower() == Global.next_spawn_portal.to_lower()
			
			if matches_name or matches_var:
				$player.global_position = node.global_position + Vector2(40, 0)
				break

	# 2. ONLY show start message if starting the level fresh (NOT arriving via a portal return)
	if Global.next_spawn_portal == "":
		broadcast_banner.show_message("Enter ->")

# When player reaches the end of the level
func _on_level_end_reached() -> void:
	waiting_for_next_level = true
	broadcast_banner.show_message("Level 1 Complete! Press Enter to proceed.")

# This runs automatically when the player presses Enter/Click to close any broadcast
func _on_banner_dismissed() -> void:
	if waiting_for_next_level:
		# Change to your Level 2 scene file path
		get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
