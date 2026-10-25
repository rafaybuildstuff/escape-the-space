extends Node

# This variable must be declared here so it can remember the portal name across scenes!
var next_spawn_portal: String = ""

# Tracks whether the return portal has been unlocked yet
var portal_unlocked: bool = false

# Rocket part collection variables
var total_parts_collected: int = 0
var max_parts: int = 4

func collect_part() -> void:
	total_parts_collected += 1
	print("Part collected! Total: ", total_parts_collected, "/", max_parts)

func has_all_parts() -> bool:
	return total_parts_collected >= max_parts
