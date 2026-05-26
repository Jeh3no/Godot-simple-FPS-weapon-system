extends Node3D

class_name ShootingRange

var shoot_range_targets : Array[CharacterBody3D] = []

@export_group("Keybind variables")
@export var restart_shooting_range_action : StringName = "play_char_restart_shooting_range_action"

func _ready() -> void:
	collect_targets(self)
	
	if not InputMap.has_action(restart_shooting_range_action):
		#i put an assert instead of a push_error or  push_warning, to be sure that it won't be missed
		assert(false, "Restart shooting range input action doesn't exist, or is wrongly written")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(restart_shooting_range_action):
		restart_shoot_range()
		
func collect_targets(node : Node) -> void:
	for child in node.get_children():
			if child is ShootingRangeTarget:
				shoot_range_targets.append(child)
				
			# recursive call on the node's children
			collect_targets(child)
			
func restart_shoot_range() -> void:
	#revive all fallen targets
	for target in shoot_range_targets:
		if target.is_disabled:
			target.anim_manager.play_backwards("fall")
			target.health = target.health_ref
			if target.is_a_moving_target:
				target.revive_moving_target()
			target.is_disabled = false
	

		

		
	
