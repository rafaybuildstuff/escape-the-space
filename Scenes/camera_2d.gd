extends Camera2D

@export var random_strength: float = 20.0
@export var shake_fade: float = 2.0 # Slower fade so it lasts longer

var shake_strength: float = 0.0
var rng = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = random_offset()

# Now accepts duration (defaults to 5 seconds!)
func apply_shake(strength: float = 20.0, duration: float = 5.0) -> void:
	shake_strength = strength
	
	# Keep refreshing the shake strength for the specified duration
	var elapsed = 0.0
	while elapsed < duration:
		await get_tree().create_timer(0.1).timeout
		elapsed += 0.1
		shake_strength = strength # Keeps the earthquake rumbling steady!

func random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
