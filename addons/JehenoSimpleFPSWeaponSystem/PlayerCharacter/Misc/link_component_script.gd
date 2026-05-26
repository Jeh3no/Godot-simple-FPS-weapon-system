extends Node

class_name LinkComponent

@onready var ammo_manager : Node3D = %AmmunitionManager

func ammo_refill_link(ammo_dict : Dictionary[String, int]) -> void:
	for key in ammo_dict.keys():
		if key in ammo_manager.ammo_dict:
			var nb_ammo_to_refill : int = min(ammo_manager.max_nb_per_ammo_dict[key] - ammo_manager.ammo_dict[key], ammo_dict[key])
			ammo_manager.ammo_dict[key] += nb_ammo_to_refill
