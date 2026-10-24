extends Area2D

# Points to BroadcastBanner2 which is a sibling node in the scene
@onready var broadcast_banner_2 = $/root/game/BroadcastBanner2 # Adjust if your main scene root name is different
@export var message_text: String = "Enter ->"

var triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
		
	# Check if the colliding body is the player
	if body.is_in_group("Player") or body.name == "player" or body.name == "player2":
		triggered = true
		
		if broadcast_banner_2:
			broadcast_banner_2.show_message(message_text)
			
		# Delete the trigger area so it only happens once
		queue_free()
