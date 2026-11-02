extends CanvasLayer

class_name HUD

#player character reference variable
@onready var play_char: PlayerCharacter = $".."
@onready var weapon_manager: Node3D = %WeaponManager

#play char label references variables
@onready var current_state_label_text: Label = %CurrentStateLabelText
@onready var desired_move_speed_label_text: Label = %DesiredMoveSpeedLabelText
@onready var velocity_label_text: Label = %VelocityLabelText
@onready var velocity_vector_label_text: Label = %VelocityVectorLabelText
@onready var is_on_floor_label_text: Label = %IsOnFloorLabelText
@onready var ceiling_check_label_text: Label = %CeilingCheckLabelText
@onready var jump_buffer_label_text: Label = %JumpBufferLabelText
@onready var coyote_time_label_text: Label = %CoyoteTimeLabelText
@onready var nb_jumps_in_air_allowed_label_text: Label = %NbJumpsInAirAllowedLabelText
@onready var jump_cooldown_label_text: Label = %JumpCooldownLabelText
@onready var frames_per_second_label_text: Label = %FramesPerSecondLabelText
@onready var camera_rotation_label_text: Label = %CameraRotationLabelText
@onready var current_fov_label_text: Label = %CurrentFOVLabelText
@onready var camera_bob_vertical_offset_label_text: Label = %CameraBobVerticalOffsetLabelText

#weapon label references variables
@onready var weapon_stack_label_text: Label = %WeaponStackLabelText
@onready var weapon_name_label_text: Label = %WeaponNameLabelText
@onready var nb_ammo_in_mag_label_text: Label = %NbAmmoInMagLabelText
@onready var nb_ammo_total_label_text: Label = %NbAmmoTotalLabelText


func _ready() -> void:
	weapon_manager.weapon_stack_updated.connect(Callable(self, "update_weapon_stack_display"))


func _process(_delta: float) -> void:
	display_current_fps()

	display_play_char_properties()

	display_weapon_properties()


func display_play_char_properties() -> void:
	#player character properties
	current_state_label_text.set_text(str(play_char.state_machine.curr_state_name))
	desired_move_speed_label_text.set_text(str("%.3f" % play_char.desired_move_speed))
	velocity_label_text.set_text(str("%.3f" % play_char.velocity.length()))
	velocity_vector_label_text.set_text(
		str(
			"[ ",
			"%.3f" % play_char.velocity.x,
			",  ",
			"%.3f" % play_char.velocity.y,
			",  ",
			"%.3f" % play_char.velocity.z,
			" ]",
		)
	)
	is_on_floor_label_text.set_text(str(play_char.is_on_floor()))
	ceiling_check_label_text.set_text(str(play_char.ceiling_check.is_colliding()))
	jump_buffer_label_text.set_text(str(play_char.jump_buff_on))
	coyote_time_label_text.set_text(str("%.3f" % play_char.coyote_jump_cooldown))
	nb_jumps_in_air_allowed_label_text.set_text(str(play_char.nb_jumps_in_air_allowed))
	jump_cooldown_label_text.set_text(str("%.3f" % play_char.jump_cooldown))

	#camera properties
	camera_rotation_label_text.set_text(
		str(
			"[ ",
			"%.3f" % play_char.cam.rotation.x,
			",  ",
			"%.3f" % play_char.cam.rotation.y,
			",  ",
			"%.3f" % play_char.cam.rotation.z,
			" ]",
		)
	)
	current_fov_label_text.set_text(str(play_char.cam.fov))
	camera_bob_vertical_offset_label_text.set_text(str("%.3f" % play_char.cam.v_offset))


func update_weapon_stack_display() -> void:
	var available_weapons_name_list: Array[String] = []
	for weapon_id in weapon_manager.weapon_list.keys():
		if weapon_id in weapon_manager.weapon_stack:
			available_weapons_name_list.append(
				weapon_manager.weapon_list[weapon_id].resources.weapon_name
			)
	weapon_stack_label_text.text = "\n".join(available_weapons_name_list)


func display_weapon_properties() -> void:
	if weapon_manager.current_weapon:
		weapon_name_label_text.set_text(str(weapon_manager.current_weapon.resources.weapon_name))
		nb_ammo_in_mag_label_text.set_text(
			str(
				(
					weapon_manager.current_weapon.resources.total_ammo_in_mag
					/ weapon_manager.current_weapon.resources.nb_proj_shots_at_same_time
				),
				" / ",
				(
					weapon_manager.current_weapon.resources.total_ammo_in_mag_ref
					/ weapon_manager.current_weapon.resources.nb_proj_shots_at_same_time
				),
			)
		)
		nb_ammo_total_label_text.set_text(
			str(
				weapon_manager
				.ammo_manager
				.ammo_dict[weapon_manager.current_weapon.resources.ammo_type]
				/ weapon_manager.current_weapon.resources.nb_proj_shots_at_same_time
			)
		)


func display_current_fps() -> void:
	frames_per_second_label_text.set_text(str(Engine.get_frames_per_second()))
