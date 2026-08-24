class_name Sun
extends DirectionalLight3D


var sun_start_sun_rotation_position: Quaternion = Quaternion(Vector3.RIGHT, deg_to_rad(165.0))
var sun_end_sun_rotation_position: Quaternion = Quaternion(Vector3.RIGHT, deg_to_rad(10.0))
var sun_orbit_direction: Quaternion = Quaternion(Vector3.UP, deg_to_rad(10.0))
var sun_orbit_tilt: Quaternion = Quaternion(Vector3.FORWARD, deg_to_rad(20.0))
var sun_start_orbit_transform: Quaternion = sun_start_sun_rotation_position * sun_orbit_direction * sun_orbit_tilt
var sun_end_orbit_transform: Quaternion = sun_end_sun_rotation_position * sun_orbit_direction * sun_orbit_tilt

var sunrise_time_factor: float = 0.1
var daytime_time_factor: float = 0.2
var midday_time_factor: float = 0.5
var evening_time_factor: float = 0.7
var sunset_time_factor: float = 0.834
var sundown_time_factor: float = 0.95

var day_max_length_sec: float = 30.0 # 660.0 # 11 minutes
var day_current_length_sec: float = day_max_length_sec
var time_of_sunrise_sec: float = day_current_length_sec * sunrise_time_factor
var time_of_daytime_sec: float = day_current_length_sec * daytime_time_factor
var time_of_midday_sec: float = day_current_length_sec * midday_time_factor
var time_of_evening_sec: float = day_current_length_sec * evening_time_factor
var time_of_sunset_sec: float = day_current_length_sec * sunset_time_factor
var time_of_sundown_sec: float = day_current_length_sec * sundown_time_factor
var time_of_night_end_sec: float = day_current_length_sec + 60.0
var current_time_of_day: float = 0.0
var sun_speed_mult: float

enum DAY_PHASES {SUNRISE, DAYTIME, EVENING, SUNSET, NIGHTTIME}
var current_day_phase: DAY_PHASES = DAY_PHASES.SUNRISE

signal day_phase_changed

var DEBUG_Stop_time: bool = false


func _ready() -> void:
	rise_for_the_day()


func _process(delta: float) -> void:
	sun_speed_mult = (1.15*PI / day_current_length_sec) * delta
	
	if current_time_of_day < day_current_length_sec and !DEBUG_Stop_time:
		current_time_of_day += delta
		rotate_object_local(Vector3.RIGHT, sun_speed_mult)
	elif current_time_of_day < time_of_night_end_sec:
		current_time_of_day += delta
	
	if current_time_of_day < time_of_daytime_sec and current_day_phase != DAY_PHASES.SUNRISE:
		current_day_phase = DAY_PHASES.SUNRISE
	elif current_time_of_day < time_of_evening_sec and current_day_phase != DAY_PHASES.DAYTIME:
		current_day_phase = DAY_PHASES.DAYTIME
	elif current_time_of_day < time_of_sunset_sec and current_day_phase != DAY_PHASES.EVENING:
		current_day_phase = DAY_PHASES.EVENING
	elif current_time_of_day < time_of_sundown_sec and current_day_phase != DAY_PHASES.SUNSET:
		current_time_of_day = DAY_PHASES.SUNSET
	elif current_time_of_day > time_of_sundown_sec and current_day_phase != DAY_PHASES.NIGHTTIME:
		current_day_phase = DAY_PHASES.NIGHTTIME


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_set_time_sunrise"):
		rise_for_the_day()
	
	if event.is_action_pressed("DEBUG_set_time_midday"):
		transform.basis = Basis(sun_start_orbit_transform.slerp(sun_end_orbit_transform, -0.5))
		current_time_of_day = time_of_midday_sec
	
	if event.is_action_pressed("DEBUG_set_time_sunset"):
		transform.basis = Basis(sun_end_orbit_transform)
		current_time_of_day = time_of_sunset_sec
	
	if event.is_action_pressed("DEBUG_Progress_Sun_March"):
		rotate_object_local(Vector3.RIGHT, sun_speed_mult * 10.0)
		current_time_of_day += 10
	
	if event.is_action_pressed("DEBUG_Rewind_Sun_March"):
		rotate_object_local(Vector3.LEFT, sun_speed_mult * 10.0)
		current_time_of_day -= 10

	if event.is_action_pressed("escape"):
		DEBUG_Stop_time = !DEBUG_Stop_time


func rise_for_the_day() -> void:
	transform.basis = Basis(sun_start_orbit_transform)
	current_time_of_day = 0.0
	day_current_length_sec = day_max_length_sec


func _morning_started_emitted() -> void:
	print("morning started")
