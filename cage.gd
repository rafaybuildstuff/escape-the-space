extends StaticBody2D

@export var max_health: int = 10
var current_health: int = 10

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	current_health = max_health
	update_animation()

# This function is called when your bullet hits the cage
func take_damage(amount: int = 1) -> void:
	# Prevent taking more damage once it's already broken/open
	if current_health <= 0:
		return

	current_health -= amount
	print("Cage health: ", current_health)
	
	update_animation()

	if current_health <= 0:
		# Disable collision permanently so the player can walk through
		if collision_shape:
			collision_shape.set_deferred("disabled", true)
		
		# Note: We removed the queue_free() code so the open cage stays on screen forever!

func update_animation() -> void:
	if not sprite:
		return
		
	# Since max_health is 10:
	# 6 to 10 health = "idle"
	# 1 to 5 health = "half open"
	# 0 or less = "open"
	if current_health > 5:
		sprite.play("idle")
	elif current_health > 0:
		sprite.play("half open")
	else:
		sprite.play("open")
