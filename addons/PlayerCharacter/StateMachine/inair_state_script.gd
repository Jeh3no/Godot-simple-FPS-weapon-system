extends State

class_name InairState

var state_name : String = "Inair"

var play_char : CharacterBody3D

func enter(play_char_ref : CharacterBody3D) -> void:
	play_char = play_char_ref
	
	verifications()
	
func verifications() -> void:
	if play_char.floor_snap_length != 0.0:  play_char.floor_snap_length = 0.0
	if play_char.hit_ground_cooldown != play_char.hit_ground_cooldown_ref: play_char.hit_ground_cooldown = play_char.hit_ground_cooldown_ref
	
	play_char.tween_hitbox_height(play_char.base_hitbox_height)
	play_char.tween_model_height(play_char.base_model_height)
	
func physics_update(delta : float) -> void:
	applies(delta)
	
	play_char.gravity_apply(delta)
	
	input_management()
	
	move(delta)
	
func applies(delta : float) -> void:
	if !play_char.is_on_floor(): 
		if play_char.jump_cooldown > 0.0: play_char.jump_cooldown -= delta
		if play_char.coyote_jump_cooldown > 0.0: play_char.coyote_jump_cooldown -= delta
		
	if play_char.is_on_floor():
		if play_char.jump_buff_on: 
			play_char.buffered_jump = true
			play_char.jump_buff_on = false
			transitioned.emit(self, "JumpState")
		else:
			if play_char.move_direction: transitioned.emit(self, play_char.walk_or_run)
			else: transitioned.emit(self, "IdleState")
		
func input_management() -> void:
	if Input.is_action_just_pressed(play_char.jump_action):
		#check if can jump buffer
		if play_char.floor_check.is_colliding() and play_char.last_frame_position.y > play_char.position.y and play_char.nb_jumps_in_air_allowed <= 0: 
			play_char.jump_buff_on = true
		#check if can coyote jump
		if play_char.was_on_floor and play_char.coyote_jump_cooldown > 0.0 and play_char.last_frame_position.y > play_char.position.y and play_char.jump_cooldown < 0.0:
			play_char.coyote_jump_on = true
			transitioned.emit(self, "JumpState")
		if play_char.jump_cooldown < 0.0:
			transitioned.emit(self, "JumpState")
			
func move(delta : float) -> void:
	play_char.input_direction = Input.get_vector(play_char.move_left_action, play_char.move_right_action, play_char.move_forward_action, play_char.move_backward_action)
	play_char.move_direction = (play_char.cam_holder.global_basis * Vector3(play_char.input_direction.x, 0.0, play_char.input_direction.y)).normalized()
	
	play_char.desired_move_speed = clamp(play_char.desired_move_speed, 0.0, play_char.max_desired_move_speed)
	
	if !play_char.is_on_floor():
		if play_char.move_direction:
			if play_char.desired_move_speed < play_char.max_desired_move_speed: play_char.desired_move_speed += play_char.bunny_hop_dms_incre * delta
			
			#use of curves here to have a better in air movement
			var contrd_des_move_speed : float = play_char.desired_move_speed_curve.sample(play_char.desired_move_speed)
			var contrd_in_air_move_speed : float = play_char.in_air_move_speed_curve.sample(play_char.desired_move_speed) * 1.0
			
			play_char.velocity.x = lerp(play_char.velocity.x, play_char.move_direction.x * contrd_des_move_speed, contrd_in_air_move_speed * delta)
			play_char.velocity.z = lerp(play_char.velocity.z, play_char.move_direction.z * contrd_des_move_speed, contrd_in_air_move_speed * delta)
			
			
