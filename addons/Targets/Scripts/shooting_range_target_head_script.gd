extends StaticBody3D

@onready var parent : CharacterBody3D = $".."

func hitscan_hit(damage_val : float, hitscan_dir : Vector3, hitscan_pos : Vector3) -> void:
	if parent != null: parent.hitscan_hit(damage_val, hitscan_dir, hitscan_pos)
