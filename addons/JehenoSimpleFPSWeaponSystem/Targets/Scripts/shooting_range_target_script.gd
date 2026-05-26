extends CharacterBody3D

class_name ShootingRangeTarget

@export var health : float = 100.0
var health_ref : float
var is_disabled : bool = false
@export var is_a_moving_target : bool = false
@export var move_speed : float 
var is_moving : bool = true
@export var travel_points : Array[Marker3D] = []
var current_travel_point_index : int = 0
@export var time_to_wait_between_each_travel_point : float
var origin_point : Marker3D
var reviving : bool = false

@onready var anim_manager : AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	health_ref = health
	anim_manager.play("idle")
	
	if !travel_points.is_empty():
		origin_point = travel_points[0]
	
func _physics_process(_delta: float) -> void:
	if is_a_moving_target and !is_disabled and !reviving:
		await update_movement()
		move_and_slide()
	elif is_a_moving_target and is_disabled and !reviving:
		if velocity != Vector3.ZERO: velocity = Vector3.ZERO
		
func update_movement() -> void:
	if travel_points.size() < 2 or !is_moving:
		velocity = Vector3.ZERO
		return
		
	var target: Vector3 = travel_points[current_travel_point_index].global_position
	var direction: Vector3 = target - global_position
	
	if direction.length() < 0.1:
		velocity = Vector3.ZERO
		is_moving = false
		await wait_and_switch_point()
	else:
		velocity = direction.normalized() * move_speed
		
func wait_and_switch_point() -> void:
	await get_tree().create_timer(time_to_wait_between_each_travel_point).timeout
	current_travel_point_index = (current_travel_point_index + 1) % travel_points.size()
	is_moving = true
	
func revive_moving_target() -> void:
	reviving = true
	await get_tree().create_timer(0.5).timeout
	reviving = false
		
func hitscan_hit(damage_val : float, _hitscan_dir : Vector3, _hitscan_pos : Vector3) -> void:
	health -= damage_val
	
	print("Hitscan hit, target health : ", health)
	
	if health <= 0.0 and !is_disabled:
		is_disabled = true
		anim_manager.play("fall")
		
func projectile_hit(damage_val : float, _hitscan_dir : Vector3) -> void:
	health -= damage_val
	
	print("Projectile hit, target health : ", health)
	
	if health <= 0.0 and !is_disabled:
		is_disabled = true
		anim_manager.play("fall")
		
		
		
		
		
		
		
		
		
