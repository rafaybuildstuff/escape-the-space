extends Area2D

@export_file("*.tscn") var target_scene: String
@export var target_portal_name: String = ""    # Name of the marker in the next scene
@export var is_active: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	if not Global.portal_unlocked and name.to_lower().contains("portal 3"):
		hide_portal()
	else:
		show_portal()

func hide_portal() -> void:
	if sprite:
		sprite.visible = false
	if collision_shape:
		collision_shape.set_deferred("disabled", true)

func show_portal() -> void:
	if sprite:
		sprite.visible = true
	if collision_shape:
		collision_shape.set_deferred("disabled", false)

func _on_body_entered(body: Node2D) -> void:
	if not is_active:
		return

	if body.name.to_lower().contains("player") or body.is_in_group("Player") or body.is_in_group("player"):
		if target_scene != "":
			# Set the spawn marker name for the destination scene
			Global.next_spawn_portal = target_portal_name
			print("Portal entered! Destination will be: ", target_portal_name)
			
			# If returning from Level 2, unlock Portal 3 on the main scene
			if "game.tscn" in target_scene:
				Global.portal_unlocked = true

			get_tree().change_scene_to_file(target_scene)
