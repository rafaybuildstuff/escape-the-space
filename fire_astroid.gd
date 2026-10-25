extends Area2D

@export var fall_speed: float = 400.0 # Faster speed for continuous rain
var active: bool = false
var original_y: float = 0.0 # To remember starting height in the sky

func _ready() -> void:
	# Hide and disable on start so they aren't visible before the shake
	visible = false
	monitoring = false
	original_y = global_position.y # Save starting height for looping
	
	# Connect signal to detect when it hits the ground or player
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if not active:
		return

	# Move downward continuously
	global_position.y += fall_speed * delta

	# Continuous looping: sends them back to the sky once they fall past the level
	if global_position.y > 1200: 
		global_position.y = original_y - 800

func trigger_fall() -> void:
	visible = true
	monitoring = true
	active = true

func _on_body_entered(body: Node2D) -> void:
	# If it hits the player, reload the game scene safely
	if body.name.to_lower().contains("player") or body.is_in_group("Player") or body.is_in_group("player"):
		call_deferred("_reload_game")
		return

	# If it hits land/tiles, recycle it back to the top for continuous rain
	if body is TileMap or body is StaticBody2D or body.name.to_lower().contains("ground") or body.name.to_lower().contains("tile"):
		global_position.y = original_y - 800

# Helper function to change scenes safely outside of the physics callback
func _reload_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
