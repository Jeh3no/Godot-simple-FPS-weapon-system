extends Node3D

class_name WeaponManager

var weapon_stack : Array[int] #weapons current wielded by play char
var weapon_list : Dictionary[int, WeaponSlot] #all weapons available in the game (key = weapon id, value = weapon slot)
@export var start_weapons : Array[WeaponSlot] #the weapons the player character will start with

var current_weapon : WeaponSlot = null #current weapon (weapon slot)
var weapon_index : int = 0

#weapon changes variables
var can_change_weapons : bool = true
var can_use_weapon : bool = true

@export_group("Keybind variables")
var shoot_action : StringName
var reload_action : StringName
var weapon_wheel_up_action : StringName
var weapon_wheel_down_action : StringName

@onready var camera_recoil_holder: CameraRecoilHolder = %CameraRecoilHolder
@onready var viewport_cam: ViewportCamera = %ViewportCam
@onready var weapon_container : Node3D = %WeaponContainer
@onready var shoot_manager : Node3D = %ShootManager
@onready var reload_manager : Node3D = %ReloadManager
@onready var ammo_manager : Node3D = %AmmunitionManager
@onready var anim_player : AnimationPlayer = %AnimationPlayer
@onready var anim_manager : Node3D = %AnimationManager
@onready var audio_manager : PackedScene = preload("../../Misc/AudioManager/audio_manager_scene.tscn")
@onready var bullet_decal : PackedScene = preload("../../Weapons/Scenes/bullet_decal_scene.tscn")
@onready var hud : HUD = %HUD
@onready var link_component : Node = %LinkComponent
@onready var input_management_component: InputManagementComponent = %InputManagementComponent

signal weapon_stack_updated

func _ready() -> void:
	await initialize()
	
func initialize() -> void:
	#stok all weapons
	for weapon in weapon_container.get_children():
		weapon.model.hide() #cache tous les modèles
		weapon_list[weapon.resources.weapon_id] = weapon #add weapon slot sript, not weapon model
		
	#stok all urrently aessible weapons for the play har
	for weapon in start_weapons:
		weapon_stack.append(weapon.resources.weapon_id)
		force_attack_point_transform_values(weapon.attack_point)
	weapon_stack_updated.emit()
	
	#enter first weapon
	if weapon_stack.size() > 0:
		await enter_weapon(weapon_stack[0])
	else:
		push_error("Play har has no weapons in his inventory")
		
func exit_weapon(next_weapon : int) -> void:
	#this function manage the first part of the weapon switching mechanic
	#in this part, the current weapon is disabled (unequiped and taked down)
	can_change_weapons = false
	can_use_weapon = false
	if current_weapon.resources.is_shooting: current_weapon.resources.is_shooting = false
	if current_weapon.resources.is_reloading: current_weapon.resources.is_reloading = false
		
	if current_weapon.resources.unequip_anim_name != "":
		anim_manager.play_animation("UnequipAnim%s" % current_weapon.resources.weapon_name, current_weapon.resources.unequip_anim_speed, false)
	await get_tree().create_timer(current_weapon.resources.unequip_time).timeout
		
	current_weapon.model.hide()
		
	await enter_weapon(next_weapon)
	
func enter_weapon(next_weapon : int) -> void:
	#this function manage the second part of the weapon switching mechanic
	#in this part, the next weapon is enabled (equiped and set up)
	current_weapon = weapon_list[next_weapon]
	next_weapon = 0
	current_weapon.model.show()
	
	shoot_manager.get_current_weapon(current_weapon)
	reload_manager.get_current_weapon(current_weapon)
	anim_manager.get_current_weapon(current_weapon)
	
	await weapon_sound_management(current_weapon.resources.equip_sound, current_weapon.resources.equip_sound_speed)
	
	anim_player.playback_default_blend_time = current_weapon.resources.anim_blend_time
	
	if current_weapon.resources.equip_anim_name != "":
		anim_manager.play_animation("EquipAnim%s" % current_weapon.resources.weapon_name, current_weapon.resources.equip_anim_speed, false)
	await get_tree().create_timer(current_weapon.resources.equip_time).timeout
	
	if current_weapon.resources.is_shooting: current_weapon.resources.is_shooting = false
	if current_weapon.resources.is_reloading: current_weapon.resources.is_reloading = false
	can_use_weapon = true
	can_change_weapons = true
	
	weapon_stack_updated.emit() #let in here for now, since there isn't any mechanic that can influence the weapon stack (for example a pick and drop weapon mechanic)
	
func _process(_delta : float) -> void:
	if current_weapon and current_weapon.resources and can_use_weapon:
		await weapon_inputs()
		
		reload_manager.auto_reload()
		
	rotate_relative_to_viewport_camera()
		
func weapon_inputs() -> void:
	if Input.is_action_pressed(shoot_action): shoot_manager.shoot()
			
	if Input.is_action_just_pressed(reload_action): reload_manager.reload()
	
	if Input.is_action_just_pressed(weapon_wheel_up_action):
		if can_change_weapons and !current_weapon.resources.is_shooting and !current_weapon.resources.is_reloading:
			weapon_index = min(weapon_index + 1, weapon_stack.size() - 1) #from first element of weapon stack to last element 
			await change_weapon(weapon_stack[weapon_index])
			
	if Input.is_action_just_pressed(weapon_wheel_down_action):
		if can_change_weapons and !current_weapon.resources.is_shooting and !current_weapon.resources.is_reloading:
			weapon_index = max(weapon_index - 1, 0) #from last element of weapon stack to first element 
			await change_weapon(weapon_stack[weapon_index])
			
func change_weapon(next_weapon : int) -> void:
	if can_change_weapons and !current_weapon.resources.is_shooting and !current_weapon.resources.is_reloading:
		await exit_weapon(next_weapon)
	else:
		push_error("Can't change weapon now")
		return 
		
func rotate_relative_to_viewport_camera() -> void:
	global_rotation = viewport_cam.global_rotation
	
func display_muzzle_flash() -> void:
	#create a muzzle flash instance, and display it at the indicated point
	if current_weapon.resources.muzzle_flash_ref:
		var muzzle_flash_ins : GPUParticles3D = current_weapon.resources.muzzle_flash_ref.instantiate()
		add_child(muzzle_flash_ins)
		muzzle_flash_ins.global_position = current_weapon.muzzle_flash_spawner.global_position
		muzzle_flash_ins.emitting = true
	else:
		push_error("%s doesn't have a muzzle flash reference" % current_weapon.resources.weapon_name)
		return
		
func display_bullet_hole(collider_point : Vector3, collider_normal : Vector3) -> void:
	#create a muzzle flash instance, and display it at the indicated point
	var bullet_decal_instance : Node3D = bullet_decal.instantiate()
	get_tree().get_root().add_child(bullet_decal_instance)
	bullet_decal_instance.global_position = collider_point
	bullet_decal_instance.look_at(collider_point - collider_normal, Vector3.UP)
	bullet_decal_instance.rotate_object_local(Vector3(1.0, 0.0, 0.0), 90)
	
func weapon_sound_management(sound_name : AudioStream, sound_speed : float) -> void:
	var audio_ins : AudioStreamPlayer3D = audio_manager.instantiate()
	get_tree().get_root().add_child.call_deferred(audio_ins)
	#makes sure the node is in the scene tree
	await get_tree().process_frame
	if audio_ins.is_inside_tree():
		audio_ins.global_transform = current_weapon.attack_point.global_transform
		audio_ins.bus = "SFX"
		audio_ins.pitch_scale = sound_speed
		audio_ins.stream = sound_name
		audio_ins.play()
	else:
		print("The sound can't be played, AudioStreamPlayer3D instance is not in the scene tree")
	
func force_attack_point_transform_values(attack_point : Marker3D) -> void:
	#reset the attack points rotation values, to ensure that the projectiles will be shot in the correct direction
	if attack_point.rotation != Vector3.ZERO: attack_point.rotation = Vector3.ZERO
