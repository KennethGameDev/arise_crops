class_name Sun
extends DirectionalLight3D


var sunrise_sun_rotation_position: Quaternion = Quaternion(Vector3.RIGHT, deg_to_rad(160.0))
var sunset_sun_rotation_position: Quaternion = Quaternion(Vector3.RIGHT, deg_to_rad(10.0))
var sun_orbit_direction: Quaternion = Quaternion(Vector3.UP, deg_to_rad(10.0))
var sun_orbit_tilt: Quaternion = Quaternion(Vector3.FORWARD, deg_to_rad(20.0))
var sunrise_orbit_transform: Quaternion = sunrise_sun_rotation_position * sun_orbit_direction * sun_orbit_tilt
var sunset_orbit_transform: Quaternion = sunset_sun_rotation_position * sun_orbit_direction * sun_orbit_tilt

var day_night_cycle_max_length_sec: float = 60.0 # 1440.0 # 24 minutes
var day_night_cycle_current_length_sec: float = day_night_cycle_max_length_sec
var time_of_sunrise_sec: float = day_night_cycle_current_length_sec * 0.25 # 06:00
var time_of_noon_sec: float = day_night_cycle_current_length_sec * 0.5 # 12:00
var time_of_sunset_sec: float = day_night_cycle_current_length_sec * 0.834 # 20:00
var time_of_sundown_sec: float = day_night_cycle_current_length_sec * 0.875 # 21:00
var time_of_midnight_sec: float = day_night_cycle_current_length_sec
var current_time_of_day: float = time_of_sunrise_sec
var sun_speed_mult: float


func _ready() -> void:
	transform.basis = Basis(sunrise_orbit_transform)
	Main.sun = self


func _process(delta: float) -> void:
	current_time_of_day += delta
	if current_time_of_day > day_night_cycle_current_length_sec:
		current_time_of_day = 0
	# print(current_time_of_day)

	sun_speed_mult = 2*PI / day_night_cycle_current_length_sec

	rotate_object_local(Vector3.RIGHT, sun_speed_mult * delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_set_time_sunrise"):
		transform.basis = Basis(sunrise_orbit_transform)
		current_time_of_day = time_of_sunrise_sec
		day_night_cycle_current_length_sec = day_night_cycle_max_length_sec
	
	if event.is_action_pressed("DEBUG_set_time_midday"):
		transform.basis = Basis(sunrise_orbit_transform.slerp(sunset_orbit_transform, -0.5))
		current_time_of_day = time_of_noon_sec
	
	if event.is_action_pressed("DEBUG_set_time_sunset"):
		transform.basis = Basis(sunset_orbit_transform)
		current_time_of_day = time_of_sunset_sec
	
	if event.is_action_pressed("DEBUG_Speed_Up_Time"):
		update_day_night_cycle_length(day_night_cycle_current_length_sec / 1.25)

	if event.is_action_pressed("DEBUG_Slow_Down_Time"):
		update_day_night_cycle_length(day_night_cycle_current_length_sec * 1.25)
	
	if event.is_action_pressed("DEBUG_Progress_Sun_March"):
		rotate_object_local(Vector3.RIGHT, sun_speed_mult * 10.0)
		current_time_of_day += 10
	
	if event.is_action_pressed("DEBUG_Rewind_Sun_March"):
		rotate_object_local(Vector3.LEFT, sun_speed_mult * 10.0)
		current_time_of_day -= 10


func update_day_night_cycle_length(new_length_sec: float) -> void:
	day_night_cycle_current_length_sec = new_length_sec
	time_of_sunrise_sec = day_night_cycle_current_length_sec * 0.25 # 06:00
	time_of_noon_sec = day_night_cycle_current_length_sec * 0.5 # 12:00
	time_of_sunset_sec = day_night_cycle_current_length_sec * 0.834 # 20:00
	time_of_sundown_sec = day_night_cycle_current_length_sec * 0.875 # 21:00
	time_of_midnight_sec = day_night_cycle_current_length_sec
