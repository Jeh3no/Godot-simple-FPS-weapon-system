extends RigidBody3D

func hitscan_hit(propul_force : float, propul_dir: Vector3, propul_pos : Vector3) -> void:
	var hit_pos : Vector3 = propul_pos - global_transform.origin #set the position to launch the object at
	if propul_dir != Vector3.ZERO: apply_impulse(propul_dir * propul_force, hit_pos)
	
func projectile_hit(propul_force : float, propul_dir: Vector3) -> void:
	if propul_dir != Vector3.ZERO: apply_central_force((global_transform.origin - propul_dir) * propul_force)
	
