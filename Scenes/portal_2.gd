extends Area2D

@export_file("*.tscn") var target_scene: String
@export var current_portal_name: String = "Portal1"
@export var destination_portal_name: String = "Portal2"

var is_traveling: bool = false

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Only trigger once so it doesn't loop or freeze if touched multiple times
	if body is CharacterBody2D and not is_traveling:
		is_traveling = true
		print("Portal entered! Starting transition...")
		
		# Optional fade effect if CanvasLayer/ColorRect exists
		var canvas_layer = get_tree().current_scene.get_node_or_null("CanvasLayer")
		if canvas_layer:
			var color_rect = canvas_layer.get_node_or_null("ColorRect")
			if color_rect:
				var tween = create_tween()
				tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)
				await tween.finished
		
		# Fallback delay to ensure it always switches scenes
		await get_tree().create_timer(1.0).timeout
		
		# Save destination and change scene
		Global.next_spawn_portal = destination_portal_name
		
		if target_scene != "":
			get_tree().change_scene_to_file(target_scene)
