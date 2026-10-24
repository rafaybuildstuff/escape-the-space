extends Area2D

@export var max_hits: int = 10
@export var half_hits: int = 5

var current_hits: int = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if animated_sprite:
		animated_sprite.play("idle")


# Called automatically by weapon script when shot!
func take_damage(amount: int = 1) -> void:
	current_hits += amount
	print("Cage hit! Current hits: ", current_hits, "/", max_hits)

	if current_hits >= max_hits:
		open_cage()
	elif current_hits >= half_hits:
		half_open_cage()


func half_open_cage() -> void:
	if animated_sprite and animated_sprite.animation != "half open":
		animated_sprite.play("half open")
		print("Cage is half open!")


func open_cage() -> void:
	if animated_sprite:
		animated_sprite.play("open")
	
	# Disables collision so player can walk inside and collect the item
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
		
	print("Cage fully open!")
