extends CharacterBody2D

@export var speed: float = 80.0
@export var gravity: float = 980.0
@export var max_health: int = 3

var current_health: int = 3
var direction: int = 1 

# These now match your exact scene tree nodes!
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var edge_detector: RayCast2D = $RayCast2D
@onready var player_detector: Area2D = $PlayerDetector

func _ready() -> void:
	current_health = max_health
	if player_detector:
		player_detector.body_entered.connect(_on_player_detector_body_entered)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall() or not edge_detector.is_colliding():
		flip_direction()

	velocity.x = direction * speed
	move_and_slide()

func flip_direction() -> void:
	direction *= -1
	if sprite:
		sprite.flip_h = (direction < 0)
	if edge_detector:
		edge_detector.position.x = abs(edge_detector.position.x) * direction

func take_damage(amount: int = 1) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	queue_free()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		get_tree().reload_current_scene()
