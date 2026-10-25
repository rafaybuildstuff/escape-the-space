extends Area2D

@export var has_triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower().contains("player") and not has_triggered:
		has_triggered = true
		print("Player stepped on danger tile! Earthquake starting...")
		trigger_earthquake()

func trigger_earthquake() -> void:
	# 1. Start Camera Shake for 5 seconds
	var camera = get_tree().root.get_camera_2d()
	if camera and camera.has_method("apply_shake"):
		camera.apply_shake(25.0, 5.0)
	
	# 2. Start transition/fade if you have it
	var fade_node = get_node_or_null("../FadeLayer/BlackScreen") 
	if fade_node and fade_node.has_method("start_transition"):
		var bg_nodes = get_tree().get_nodes_in_group("background")
		fade_node.start_transition(bg_nodes)
		
	# 3. Wait for 4 seconds WHILE the earthquake is shaking, then start the meteors!
	await get_tree().create_timer(4.0).timeout
	
	print("4 seconds passed! Starting meteor rain during the earthquake!")
	
	# Turn sky red
	var canvas_mod = get_tree().root.find_child("CanvasModulate", true, false)
	if canvas_mod:
		canvas_mod.color = Color(1.0, 0.3, 0.3)
		
	# 4. Wake up all the fire asteroids you placed in the level with random delays!
	var asteroids = get_tree().get_nodes_in_group("fire_asteroids")
	for asteroid in asteroids:
		var random_delay = randf_range(0.0, 1.0)
		await get_tree().create_timer(random_delay).timeout
		
		if asteroid.has_method("trigger_fall"):
			asteroid.trigger_fall()
