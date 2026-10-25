extends Area2D

@export_file("*.tscn") var target_scene: String
@export var current_portal_name: String = "portal2"     # Name of THIS portal node
@export var destination_portal_name: String = "portal"  # Where to land back in Level 1

var is_traveling: bool = false

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)
	
	# If we just arrived AT this portal, place the player at the SpawnMarker
	if Global.next_spawn_portal == name:
		print("Spawn match found in Level 2! Placing player at SpawnMarker.")
		var player = get_tree().current_scene.get_node_or_null("player2")
		if not player:
			player = get_tree().current_scene.get_node_or_null("player")
			
		if player:
			var spawn_marker = get_node_or_null("SpawnMarker")
			if spawn_marker:
				player.global_position = spawn_marker.global_position
			else:
				# Fallback if marker isn't found
				player.global_position = global_position + Vector2(100, 0)
		
		Global.next_spawn_portal = ""

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_traveling:
		is_traveling = true
		print("Level 2 portal entered! Returning to Level 1...")
		
		# Optional fade effect
		var canvas_layer = get_tree().current_scene.get_node_or_null("CanvasLayer")
		if canvas_layer:
			var color_rect = canvas_layer.get_node_or_null("ColorRect")
			if color_rect:
				var tween = create_tween()
				tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)
				await tween.finished
		
		await get_tree().create_timer(0.5).timeout
		
		# Unlock Portal 3 in the main scene since we are returning!
		Global.portal_unlocked = true
		Global.next_spawn_portal = destination_portal_name
		
		if target_scene != "":
			get_tree().change_scene_to_file(target_scene)
