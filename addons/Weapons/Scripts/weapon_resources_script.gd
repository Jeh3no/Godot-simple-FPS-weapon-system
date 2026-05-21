extends Resource

class_name WeaponResource

@export_group("General variables")
@export var weapon_name : String
@export var weapon_id : int
var weapon_slot : WeaponSlot

@export_group("Type variables")
enum types
{
	NULL, HITSCAN, PROJECTILE
}
@export var type = types.NULL 

@export_group("Animation variables")
@export var anim_blend_time : float
@export var equip_anim_name : String
@export var equip_anim_speed : float = 1.0
@export var unequip_anim_name : String
@export var unequip_anim_speed : float = 1.0
@export var shoot_anim_name : String
@export var shoot_anim_speed : float = 1.0
@export var reload_anim_name : String
@export var reload_anim_speed : float = 1.0

@export_group("Sound variables")
@export var equip_sound : AudioStream
@export var equip_sound_speed : float = 1.0
@export var unequip_sound : AudioStream
@export var unequip_sound_speed : float = 1.0
@export var shoot_sound : AudioStream
@export var shoot_sound_speed : float = 1.0
@export var reload_sound : AudioStream
@export var reload_sound_speed : float = 1.0

@export_group("Ammunition variables")
@export var total_ammo_in_mag : int 
@export var total_ammo_in_mag_ref : int 
@export_enum("LightAmmo", "MediumAmmo", "HeavyAmmo", "ShellAmmo", "ExplosiveAmmo")  var ammo_type : String = "LightAmmo"
@export var all_ammo_in_mag : bool = false

@export_group("Equip variables")
@export var equip_time : float

@export_group("Unequip variables")
@export var unequip_time : float

@export_group("Shoot variables")
var is_shooting : bool = false 
@export var can_auto_shoot : bool 
@export var nb_proj_shots_at_same_time : int = 1
@export var nb_proj_shots : int = 1
@export var min_spread : float
@export var max_spread : float 
@export var max_range : float 
@export var damage_per_proj : float 
@export var damage_dropoff : Curve
@export_range(0.0, 15.0, 0.01) var headshot_damage_mult : float = 1.0
@export var time_between_shots : float 

@export_group("Reload variables")
var is_reloading : bool = false
@export var has_to_reload : bool = true
@export var auto_reload : bool = true
@export var nb_parts_needed : int = 1
@export var reload_time_per_part : float

@export_group("Recoil variables")
@export var base_rot_speed : float
@export var target_rot_speed : float
@export var recoil_val : Vector3 = Vector3.ZERO

@export_group("Projectile variables")
@export var is_proj_explosive : bool = false
@export var proj_ref : PackedScene
@export var proj_move_speed : float 
@export var proj_time_before_vanish : float 
@export var proj_gravity_val : float

@export_group("Position variables")
@export var pos_val : Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
@export var back_to_origin_pos_speed : float 

@export_group("Tilt variables")
@export_enum("X", "Y", "Z") var axis_to_tilt : String = "Y"
@export var tilt_rot_speed : float
@export var tilt_rot_amount : float

@export_group("Sway variables")
@export var min_sway_val : Vector2 = Vector2.ZERO
@export var max_sway_val : Vector2 = Vector2.ZERO
@export var sway_speed_pos : float
@export var sway_speed_rot : float
@export var sway_amount_pos : float
@export var sway_amount_rot : float

@export_group("Bob variables")
@export var bob_pos_val : Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
@export var bob_freq : float
@export var bob_amount : float
@export var bob_speed : float

@export_group("Muzzle flash variables")
@export var muzzle_flash_ref : PackedScene
@export var show_muzzle_flash : bool
