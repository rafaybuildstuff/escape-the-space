extends Node2D

@export var asteroid_scene: PackedScene
@export var spawn_interval: float = 0.4

var is_active: bool = false
var timer: float = 0.0

func start_meteor_shower() -> void:
	is_active = true
	print("METEOR SHOWER STARTED!")

func _process(delta: float) -> void:
	if not is_active:
		return
		
	timer += delta
	if timer >= spawn_interval:
		timer = 0.0
		spawn_meteor()

func spawn_meteor() -> void:
	if asteroid_scene == null:
		print("Error: Asteroid scene is empty in the Spawner inspector!")
		return
		
	var asteroid = asteroid_scene.instantiate()
	
	# Get current camera position so meteors rain down over the player anywhere on the map
	var camera = get_viewport().get_camera_2d()
	var spawn_x = camera.global_position.x if camera else global_position.x
	
	# Randomly choose Left or Right side relative to camera view
	var spawn_from_left = randf() > 0.5
	
	if spawn_from_left:
		asteroid.global_position = Vector2(spawn_x + randf_range(-600, 200), -800)
		asteroid.velocity = Vector2(randf_range(100, 200), randf_range(300, 500))
	else:
		asteroid.global_position = Vector2(spawn_x + randf_range(200, 600), -800)
		asteroid.velocity = Vector2(randf_range(-200, -100), randf_range(300, 500))
		
		var spr = asteroid.get_node_or_null("Sprite2D")
		if spr:
			spr.flip_h = true

	get_tree().current_scene.add_child(asteroid)
