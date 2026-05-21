extends Node3D

class_name ExplosionParticleEffect

var position_to_follow : Vector3
var particle_to_emit : String
var life_time : float

@onready var debris : GPUParticles3D = $DebrisParticles
@onready var smoke : GPUParticles3D = $SmokeParticles
@onready var fire : GPUParticles3D = $FireParticles

func _ready() -> void:
	match particle_to_emit:
		"Explosion":
			life_time = smoke.lifetime
			debris.emitting = true
			smoke.emitting = true
			fire.emitting = true
			
	await get_tree().create_timer(life_time).timeout
	
	queue_free()
