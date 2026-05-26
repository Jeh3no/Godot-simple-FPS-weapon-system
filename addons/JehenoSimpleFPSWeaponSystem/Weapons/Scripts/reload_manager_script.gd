extends Node3D

var reload_time : float
var start_reload_timer : bool = false #has to be initilated at start
var current_part_index : int
var play_sound_and_anim : bool
var force_reload_stop : bool = false

var current_weapon : WeaponSlot
@onready var weapon_manager : Node3D = %WeaponManager

func get_current_weapon(current_weapon_ref : WeaponSlot) -> void:
	current_weapon = current_weapon_ref
	
func _process(delta : float) -> void:
	if current_weapon:
		if current_weapon.resources.is_reloading and start_reload_timer and !force_reload_stop:
			reload_follow(delta)
		elif force_reload_stop:
			current_weapon.resources.is_reloading = false
			start_reload_timer = false
			return
		
func reload() -> void:
	reload_start()
	
func reload_start() -> void:
	if current_weapon.resources.has_to_reload:
		if (!current_weapon.resources.is_reloading and \
		#the type of ammunition the weapon is using still as reserve
		weapon_manager.ammo_manager.ammo_dict[current_weapon.resources.ammo_type] > current_weapon.resources.nb_proj_shots_at_same_time and \
		#the magazine isn't full
		current_weapon.resources.total_ammo_in_mag != current_weapon.resources.total_ammo_in_mag_ref and \
		!current_weapon.resources.is_shooting): 
			current_weapon.resources.is_reloading = true
			
			#for more than 1 part, you need to enter a multiple of total number of ammo the magazine can contain
			#for example, for a shotgun that can contain 8 shells, the number of parts to reload possible are : 1, 2, 4, 8
			#if you choose a number like 3, or 5, it will reload 3/8, or 5/8 at once, which is not possible, so be sure to enter a number of part allowing the weapon to reload ammunition units
			if (current_weapon.resources.total_ammo_in_mag_ref % current_weapon.resources.nb_parts_needed) != 0:
				push_error("The number of parts set is not correct, cannot insert %d of ammunition" % (current_weapon.resources.nb_parts_needed / current_weapon.resources.total_ammo_in_mag_ref))
				current_weapon.resources.is_reloading = false
			else:
				current_part_index = 0
				reload_time = current_weapon.resources.reload_time_per_part
				force_reload_stop = false
				play_sound_and_anim = true
				start_reload_timer = true
				#the rest is been processed is reload_timeProcess, then reloadFollow
	else:
		print("No need to reload")
		
func reload_follow(delta : float) -> void:
	if play_sound_and_anim:
		play_sound_and_anim = false
		weapon_manager.weapon_sound_management(current_weapon.resources.reload_sound, current_weapon.resources.reload_sound_speed)
		
		if current_weapon.resources.shoot_anim_name != "":
			weapon_manager.anim_manager.play_animation("ReloadAnim%s" % current_weapon.resources.weapon_name, current_weapon.resources.reload_anim_speed, true)
		else:
			print("%s doesn't have a reload animation" % current_weapon.resources.weapon_name)
			
	if reload_time > 0.0: reload_time -= delta
	else:
		if current_part_index < current_weapon.resources.nb_parts_needed: #-1, because if not it loop one extra time
			if current_weapon.resources.nb_parts_needed == 1:
				one_part_reload_calculus()
			else:
				multi_part_reload_calculus()
				
			current_part_index += 1
			
			if current_part_index < current_weapon.resources.nb_parts_needed:
				reload_time = current_weapon.resources.reload_time_per_part
				play_sound_and_anim = true
			else:
				current_weapon.resources.is_reloading = false
		else:
			current_weapon.resources.is_reloading = false
			
func one_part_reload_calculus() -> void:
	#explanation of the use of the min function here
	#case 1: if there's enough ammo to completely refill the magazine
	#case 2: if there's not enough ammo left, we refill the magazine with the remaining ammo.
	var nb_ammo_to_refill : int = min(current_weapon.resources.total_ammo_in_mag_ref - current_weapon.resources.total_ammo_in_mag, weapon_manager.ammo_manager.ammo_dict[current_weapon.resources.ammo_type])
	
	if nb_ammo_to_refill <= current_weapon.resources.total_ammo_in_mag_ref and nb_ammo_to_refill >= current_weapon.resources.nb_proj_shots_at_same_time:
		#refill the magazine, and subtract the number from the ammo manager
		current_weapon.resources.total_ammo_in_mag += nb_ammo_to_refill
		weapon_manager.ammo_manager.ammo_dict[current_weapon.resources.ammo_type] -= nb_ammo_to_refill
		
func multi_part_reload_calculus() -> void:
	var nb_ammo_to_refill : int = current_weapon.resources.total_ammo_in_mag_ref / current_weapon.resources.nb_parts_needed
	if weapon_manager.ammo_manager.ammo_dict[current_weapon.resources.ammo_type] >= nb_ammo_to_refill and \
	current_weapon.resources.total_ammo_in_mag <= current_weapon.resources.total_ammo_in_mag_ref - nb_ammo_to_refill:
		#add number of ammo to the magazine, and substract it from the ammo manager
		current_weapon.resources.total_ammo_in_mag += nb_ammo_to_refill
		weapon_manager.ammo_manager.ammo_dict[current_weapon.resources.ammo_type] -= nb_ammo_to_refill
	else:
		print("Not enough ammunition in bag, or magazine complete")
		force_reload_stop = true
		
func auto_reload() -> void:
	#auto reload the weapon if he can reload, has to reload, has auto reload enabled, has enought ammo in the ammo manager, and the magazine is empty
	if current_weapon.resources.auto_reload and !current_weapon.resources.is_reloading and \
	weapon_manager.ammo_manager.ammo_dict[current_weapon.resources.ammo_type] > 0 and \
	current_weapon.resources.total_ammo_in_mag <= 0: 
		reload()
