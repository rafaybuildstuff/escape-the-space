extends Area2D

@export var speed: float = 450.0
@export var damage: int = 1
@export var lifetime: float = 3.0

var direction: float = 1.0
var time_alive: float = 0.0
var has_hit: bool = false

func _ready() -> void:
	# Connects to both body_entered (for enemies/platforms) and area_entered (for the cage Area2D)
	body_entered.connect(_on_hit)
	area_entered.connect(_on_hit)

func _physics_process(delta: float) -> void:
	if has_hit:
		return

	global_position.x += direction * speed * delta

	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

func _on_hit(target: Node2D) -> void:
	if has_hit or target == self:
		return

	print("Weapon touched: ", target.name)

	if target.has_method("take_damage"):
		target.take_damage(damage)
		print("Target took damage!")
		has_hit = true
		queue_free()
