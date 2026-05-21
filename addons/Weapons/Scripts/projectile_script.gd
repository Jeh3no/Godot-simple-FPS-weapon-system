extends RigidBody3D

class_name Projectile

#properties variables
var is_explosive : bool = false
var direction : Vector3 
var damage : float
var time_before_vanish : float 
var bodies_list : Array = []

#references variables
@onready var mesh = %Mesh
@onready var hitbox : CollisionShape3D = %Hitbox

@export_group("Sound variables")
@onready var audio_manager : PackedScene = preload("../../Misc/AudioManager/audio_manager_scene.tscn")
@export var explosion_sound : AudioStream

@export_group("Particles variables")
@onready var explosion_particle_effect : PackedScene = preload("../../Misc/ParticlesEffects/ExplosionParticleEffect/explosion_particle_effect_scene.tscn")

func _process(delta : float) -> void:
	if time_before_vanish > 0.0: time_before_vanish -= delta
	else: hit()
		
func _on_body_entered(body : Node3D) -> void:
	hit()
	apply_damage(body)

func hit() -> void:
	mesh.visible = false
	hitbox.set_deferred("disabled", true)
	
	if is_explosive: explode()

func apply_damage(body : Node3D) -> void:
	if body.is_in_group("Enemies") and body.has_method("projectile_hit"):
			body.projectile_hit(damage, direction)
			
	if body.is_in_group("HitableObjects") and body.has_method("projectile_hit"):
		body.projectile_hit(damage, direction)
	
func explode() -> void:
	#this function is visual and audio only, it doesn't affect the gameplay
	sound_management(explosion_sound)
	
	var particles_ins : ExplosionParticleEffect = null
	if !particles_ins:
		particles_ins = explosion_particle_effect.instantiate()
		particles_ins.particle_to_emit = "Explosion"
		particles_ins.global_transform = global_transform
		get_tree().get_root().add_child.call_deferred(particles_ins)
	else:
		print("Projectile already has emit explosion particles")
		
	queue_free()
	
func sound_management(sound : AudioStream) -> void:
	if sound != null:
		var audio_ins : AudioStreamPlayer3D = audio_manager.instantiate()
		audio_ins.global_transform = global_transform
		get_tree().get_root().add_child(audio_ins)
		audio_ins.bus = "Sfx"
		audio_ins.volume_db = 5.0
		audio_ins.stream = sound
		audio_ins.play()
