extends Area2D

var has_triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower().contains("player") and not has_triggered:
		has_triggered = true
		print("Player stepped on danger tile! Starting countdown...")
		
		# Wait 1 second before starting the earthquake
		await get_tree().create_timer(1.0).timeout
		
		trigger_earthquake()

func trigger_earthquake() -> void:
	print("EARTHQUAKE STARTED!")
	
	# 1. Start Camera Shake
	var camera = get_tree().root.get_camera_2d()
	if camera and camera.has_method("apply_shake"):
		camera.apply_shake(25.0, 5.0)
	
	# 2. Get Background Nodes
	var bg_nodes = get_tree().get_nodes_in_group("background")
	print("Found background nodes count: ", bg_nodes.size())
	
	# 3. Directly find BlackScreen
	var fade_node = get_node_or_null("../FadeLayer/BlackScreen") 
	if not fade_node:
		fade_node = get_tree().root.find_child("BlackScreen", true, false)
	
	if fade_node and fade_node.has_method("start_transition"):
		print("Fade node found directly! Starting transition...")
		fade_node.start_transition(bg_nodes)
	else:
		print("ERROR: Still couldn't find BlackScreen node!")
