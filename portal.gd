extends Area2D

# Choose your target scene file in the Inspector
@export_file("*.tscn") var target_scene: String

# The name of THIS portal (e.g., "Portal1")
@export var current_portal_name: String = "Portal1"

# The name of the destination portal in the other scene (e.g., "Portal2")
@export var destination_portal_name: String = "Portal2"

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("Portal entered! Waiting 2 seconds...")
		
		# Freeze player movement while waiting
		body.set_physics_process(false)
		
		# Wait for 2 seconds
		await get_tree().create_timer(2.0).timeout
		
		# Save destination portal name in Global
		Global.next_spawn_portal = destination_portal_name
		
		# Change to the target scene
		if target_scene != "":
			get_tree().change_scene_to_file(target_scene)
