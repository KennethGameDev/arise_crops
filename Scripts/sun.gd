extends DirectionalLight3D

@export var sun_speed_mult: float = 0.007 # About 10 minute days
var sunrise_sun_x_rot: float = 170.0
var sunset_sun_x_rot: float = 10.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_set_time_sunrise"):
		rotation.x = sunrise_sun_x_rot
	
	if event.is_action_pressed("DEBUG_set_time_midday"):
		rotation.x = 290.0
	
	if event.is_action_pressed("DEBUG_set_time_sunset"):
		rotation.x = sunset_sun_x_rot


func _process(delta: float) -> void:
	# Sun's x-rotation will progress in degrees from 10 to 0/360 to 170
	if rotation.x >= sunrise_sun_x_rot and rotation.x <= sunset_sun_x_rot:
		rotation.x += delta * sun_speed_mult
