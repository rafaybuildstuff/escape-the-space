extends Area2D

# Allows you to drag and drop the banner directly in the Inspector
@export var broadcast_banner: CanvasLayer
@onready var broadcast_banner_4: CanvasLayer = $"../BroadcastBanner4"

@export var message_text: String = "Enter ->"
var triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
		
	if body.name == "player" or body.name == "player2" or body.is_in_group("player") or body.is_in_group("player2"):
		triggered = true
		
		print("Player entered lastmessage zone! Starting 3-second timer...")
		await get_tree().create_timer(3.0).timeout
		
		if broadcast_banner:
			broadcast_banner.show_message(message_text)
			print("BroadcastBanner4 shown successfully!")
		else:
			print("ERROR: BroadcastBanner node not assigned in Inspector!")
			
		queue_free()
