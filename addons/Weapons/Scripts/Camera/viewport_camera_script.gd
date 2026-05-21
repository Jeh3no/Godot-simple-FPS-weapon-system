extends Camera3D

class_name ViewportCamera

@onready var cam : Camera3D = %Camera

func _physics_process(_delta: float) -> void:
	global_transform = cam.global_transform
