extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@export var weapon_scene: PackedScene

var gun_equipped: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Left and right movement
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0:
		animated_sprite.flip_h = direction < 0

	# Jumping
	var want_to_jump = (
		Input.is_action_just_pressed("jump") or
		Input.is_action_just_pressed("ui_accept") or
		Input.is_key_pressed(KEY_SPACE) or
		Input.is_key_pressed(KEY_W)
	)

	if want_to_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Normal gravity
	if not is_on_floor():
		velocity.y += 980.0 * delta

	# Equip or unequip gun with E
	if Input.is_key_pressed(KEY_E) and Input.is_action_just_pressed("equip_gun"):
		gun_equipped = not gun_equipped

		if gun_equipped:
			animated_sprite.play("shoot") # Plays the animation named "shoot"
		else:
			animated_sprite.play("default")

	# Fire using your Input Map action "fire_weapon"
	if gun_equipped and Input.is_action_just_pressed("fire_weapon"):
		throw_weapon()

	move_and_slide()


func throw_weapon() -> void:
	if weapon_scene == null:
		print("Weapon scene is not assigned!")
		return

	var weapon = weapon_scene.instantiate()
	get_tree().current_scene.add_child(weapon)

	weapon.global_position = global_position + Vector2(
		-25 if animated_sprite.flip_h else 25,
		0
	)

	weapon.direction = -1.0 if animated_sprite.flip_h else 1.0
