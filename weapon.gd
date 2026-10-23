
extends Area2D

@export var speed: float = 450.0
@export var damage: int = 1
@export var lifetime: float = 3.0

var direction: float = 1.0
var time_alive: float = 0.0
var has_hit: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if has_hit:
		return

	global_position.x += direction * speed * delta

	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	print("Weapon touched: ", body.name)

	if body.has_method("take_damage"):
		body.take_damage(damage)
		print("Enemy damaged!")
		has_hit = true
		queue_free()
