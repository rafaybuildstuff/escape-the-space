extends CharacterBody2D

# Space movement settings
@export var speed: float = 200.0
@export var jump_velocity: float = -300.0
@export var gravity: float = 250.0
@export var fall_gravity: float = 100.0

# Reference to the AnimatedSprite2D node
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Left and right movement
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	# Low-gravity jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Slow space gravity
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += fall_gravity * delta
		else:
			velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Toggle shooting / default state with 'e'
	if Input.is_action_just_pressed("e"):
		if animated_sprite.animation == "default":
			animated_sprite.play("shoot")
		else:
			animated_sprite.play("default")

	move_and_slide()
