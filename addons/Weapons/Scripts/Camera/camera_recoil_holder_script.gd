extends Node3D

class_name CameraRecoilHolder

#Camera recoil variables
var current_rotation : Vector3
var target_rotation : Vector3 
var base_rotation_speed : float
var target_rotation_speed : float 

func _process(delta : float) -> void:
	handle_recoil(delta)
	
func handle_recoil(delta : float) -> void:
	#first phase, the camera will aim according the recoil values
	#second phase, the camera back down to her initial rotation value
	target_rotation = lerp(target_rotation, Vector3.ZERO, base_rotation_speed * delta)
	current_rotation = lerp(current_rotation, target_rotation, target_rotation_speed * delta)
	
	rotation = current_rotation

func set_recoil_values(base_rot_speed : float, target_rot_speed : int) -> void:
	base_rotation_speed = base_rot_speed
	target_rotation_speed = target_rot_speed
	
func add_recoil(recoil_value : Vector3) -> void:
	target_rotation += Vector3(recoil_value.x, randf_range(-recoil_value.y, recoil_value.y), randf_range(-recoil_value.z, recoil_value.z))
