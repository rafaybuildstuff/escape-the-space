extends Node2D

func _ready() -> void:
	if Global.next_spawn_portal != "":
		# Look through all nodes in the level
		for node in get_children():
			# Check if the node's name matches or its export variable matches
			var matches_name = node.name.to_lower() == Global.next_spawn_portal.to_lower()
			var matches_var = "current_portal_name" in node and node.current_portal_name.to_lower() == Global.next_spawn_portal.to_lower()
			
			if matches_name or matches_var:
				$player.global_position = node.global_position + Vector2(40, 0)
				break
