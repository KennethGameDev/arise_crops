extends DirectionalLight3D

@export var sun_speed_mult: float = 0.05
var sunrise_sun_rotation_position: Quaternion = Quaternion(Vector3.RIGHT, deg_to_rad(160.0))
var sunset_sun_rotation_position: Quaternion = Quaternion(Vector3.RIGHT, deg_to_rad(10.0))
var sun_orbit_direction: Quaternion = Quaternion(Vector3.UP, deg_to_rad(10.0))
var sun_orbit_tilt: Quaternion = Quaternion(Vector3.FORWARD, deg_to_rad(20.0))
var sunrise_orbit_transform: Quaternion = sunrise_sun_rotation_position * sun_orbit_direction * sun_orbit_tilt
var sunset_orbit_transform: Quaternion = sunset_sun_rotation_position * sun_orbit_direction * sun_orbit_tilt


func _ready() -> void:
	transform.basis = Basis(sunrise_orbit_transform)


func _process(delta: float) -> void:
	rotate_object_local(Vector3.RIGHT, sun_speed_mult * delta)
	print(rad_to_deg(transform.basis.get_euler().x))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_set_time_sunrise"):
		transform.basis = Basis(sunrise_orbit_transform)
	
	if event.is_action_pressed("DEBUG_set_time_midday"):
		transform.basis = Basis(sunrise_orbit_transform.slerp(sunset_orbit_transform, -0.5))
	
	if event.is_action_pressed("DEBUG_set_time_sunset"):
		transform.basis = Basis(sunset_orbit_transform)
	
	if event.is_action_pressed("DEBUG_Speed_Up_Time"):
		sun_speed_mult += 0.1
		prints("Sun speed mult:", sun_speed_mult)

	if event.is_action_pressed("DEBUG_Slow_Down_Time"):
		sun_speed_mult -= 0.1
		prints("Sun speed mult:", sun_speed_mult)
	
	if event.is_action_pressed("DEBUG_Progress_Sun_March"):
		rotate_object_local(Vector3.RIGHT, 0.1)
	
	if event.is_action_pressed("DEBUG_Rewind_Sun_March"):
		rotate_object_local(Vector3.LEFT, 0.1)
