extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@export var weapon_scene: PackedScene

var gun_equipped: bool = false
var is_dying: bool = false # Tracks death state

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Safe node retrieval for death audio only
@onready var die_audio: AudioStreamPlayer2D = get_node_or_null("DieAudio")


func _ready() -> void:
	# Check if we transitioned from another scene via portal
	if Global.next_spawn_portal != "":
		# Find the destination portal or spawn marker in this scene
		var spawn_node = get_tree().current_scene.find_child(Global.next_spawn_portal, true, false)
		
		if spawn_node:
			# Move player offset slightly to the side (+60px) so you don't re-trigger the portal
			global_position = spawn_node.global_position + Vector2(60, 0)
		
		# Reset the global variable after spawning
		Global.next_spawn_portal = ""


func _physics_process(delta: float) -> void:
	if is_dying:
		return # Freeze inputs if the player is dying

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

	# Cleaner toggle using Input Map action "equip_gun"
	if Input.is_action_just_pressed("equip_gun"):
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


# --- DEATH FUNCTION WITH 1 SECOND EARLY AUDIO & HIDE FIX ---
func die() -> void:
	if is_dying:
		return
		
	is_dying = true
	velocity = Vector2.ZERO # Stop player movement immediately
	
	# Hide sprite and disable collision so the sound plays fully without interruption
	if animated_sprite:
		animated_sprite.visible = false
		
	var collision_shape = get_node_or_null("CollisionShape2D")
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	
	print("Player died! Playing death sound 1 second early...")
	
	# 1. Play death sound safely
	if die_audio and die_audio.stream:
		die_audio.play()
		
	# 2. Wait for 1.0 second while the audio plays out before resetting or ending scene
	await get_tree().create_timer(1.0).timeout
	
	# 3. Reload current scene or handle respawn
	get_tree().reload_current_scene()
