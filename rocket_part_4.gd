extends Area2D

var collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
		
	if body.is_in_group("player") or body.is_in_group("player2") or body.name == "player" or body.name == "player2":
		collected = true
		Global.collect_part()
		queue_free() # Disappears when picked up
