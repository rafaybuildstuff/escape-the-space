extends Area2D

@export var total_parts_required: int = 4 
@export var broadcast_banner: CanvasLayer # Drag your BroadcastBanner here in the Inspector

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $InteractArea

var player_in_range: bool = false
var is_repaired: bool = false


func _ready() -> void:
	if animated_sprite:
		animated_sprite.play("broken")
	
	if interact_area:
		interact_area.body_entered.connect(_on_interact_area_body_entered)
		interact_area.body_exited.connect(_on_interact_area_body_exited)


func _input(event: InputEvent) -> void:
	if player_in_range and not is_repaired:
		if event is InputEventKey and event.pressed and not event.is_echo():
			if event.keycode == KEY_F:
				try_repair_rocket()


func try_repair_rocket() -> void:
	# Check against our Global parts counter instead of local variables
	if Global.total_parts_collected >= total_parts_required:
		is_repaired = true
		if animated_sprite:
			animated_sprite.play("fixed")
		print("Rocket successfully repaired!")
		
		if broadcast_banner:
			broadcast_banner.show_message("Rocket Fixed! Escaping space now...")
	else:
		print("Not enough parts! Collected: ", Global.total_parts_collected, "/", total_parts_required)
		
		if broadcast_banner:
			var missing = total_parts_required - Global.total_parts_collected
			broadcast_banner.show_message("Rocket needs all parts! Missing: " + str(missing))


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.name.to_lower().contains("player"):
		player_in_range = true
		print("Player entered rocket range! Press F to fix.")


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.name.to_lower().contains("player"):
		player_in_range = false
		print("Player left rocket range.")
