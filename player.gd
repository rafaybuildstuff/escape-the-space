extends CharacterBody2D

# Space movement settings
@export var speed: float = 200.0
@export var jump_velocity: float = -200.0 # Slightly increased for a better feel
@export var gravity: float = 300.0
@export var fall_gravity: float = 80.0

# Reference to the AnimatedSprite2D node
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Left and right movement
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	# Flip sprite direction automatically
	if direction != 0:
		animated_sprite.flip_h = (direction < 0)

	# 2. Jumping 
	var want_to_jump = (
		Input.is_action_just_pressed("jump") or 
		Input.is_action_just_pressed("ui_accept") or 
		Input.is_key_pressed(KEY_SPACE) or 
		Input.is_key_pressed(KEY_W)
	)
	
	if want_to_jump and is_on_floor():
		velocity.y = jump_velocity

	# 3. Slow space gravity (Only apply if NOT jumping right this instant)
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += fall_gravity * delta
		else:
			velocity.y += gravity * delta

	# 4. Toggle shooting state with E key
	if Input.is_action_just_pressed("shoot"):
		if animated_sprite.animation == "default":
			animated_sprite.play("shoot")
		else:
			animated_sprite.play("default")

	move_and_slide()
