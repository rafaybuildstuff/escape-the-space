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
	print("EARTHQUAKE STARTED FOR 5 SECONDS!")
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("apply_shake"):
		camera.apply_shake(25.0, 5.0) # Strength 25, lasting 5 seconds!
