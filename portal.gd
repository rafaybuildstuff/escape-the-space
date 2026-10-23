extends Area2D

@export_file("*.tscn") var target_scene: String
@export var current_portal_name: String = "portal"
@export var destination_portal_name: String = "portal2"

var is_traveling: bool = false

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)
	
	# Check if we just arrived through this portal
	if Global.next_spawn_portal == name:
		print("Spawn match found! Placing player at SpawnPoint.")
		var player = get_tree().current_scene.get_node_or_null("player")
		if player:
			var spawn_point = get_node_or_null("SpawnPoint")
			if spawn_point:
				# Snap player directly to the Marker2D position you placed
				player.global_position = spawn_point.global_position
			else:
				# Fallback if marker is missing
				player.global_position = global_position + Vector2(40, 0)
		
		Global.next_spawn_portal = ""

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_traveling:
		is_traveling = true
		print("Portal entered! Destination will be: ", destination_portal_name)
		
		# Fade to black
		var color_rect = get_tree().current_scene.get_node_or_null("CanvasLayer/ColorRect")
		if color_rect and color_rect.has_method("fade_out"):
			await color_rect.fade_out()
		else:
			await get_tree().create_timer(1.0).timeout
		
		# Set destination name
		Global.next_spawn_portal = destination_portal_name
		
		if target_scene != "":
			get_tree().change_scene_to_file(target_scene)
