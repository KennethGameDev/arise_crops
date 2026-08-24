class_name Atmosphere
extends WorldEnvironment


@export var sunrise_sky_color: Color = Color.PALE_GOLDENROD
@export var daytime_sky_color: Color = Color.DEEP_SKY_BLUE
@export var evening_sky_color: Color = Color.DARK_ORANGE
@export var sunset_sky_color: Color = Color.ORANGE_RED
@export var nightime_sky_color: Color = Color.BLACK
var lerp_color: Color = nightime_sky_color
var elapsed_time: float = 0.0


func _ready() -> void:
	Main.atmosphere = self


# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("DEBUG_set_time_sunrise"):
# 		lerp_color = daytime_sky_color
	
# 	if event.is_action_pressed("DEBUG_set_time_sunset"):
# 		lerp_color = nightime_sky_color


func _process(delta: float) -> void:
	elapsed_time += delta

	match Main.sun.current_day_phase:
		Main.sun.DAY_PHASES.SUNRISE:
			lerp_color = lerp_color.lerp(sunrise_sky_color, elapsed_time / Main.sun.time_of_sunrise_sec)
		Main.sun.DAY_PHASES.DAYTIME:
			lerp_color = lerp_color.lerp(daytime_sky_color, elapsed_time / (Main.sun.time_of_daytime_sec - Main.sun.time_of_sunrise_sec))
		Main.sun.DAY_PHASES.EVENING:
			lerp_color = lerp_color.lerp(evening_sky_color, elapsed_time / (Main.sun.time_of_evening_sec - Main.sun.time_of_daytime_sec))
		Main.sun.DAY_PHASES.SUNSET:
			lerp_color = lerp_color.lerp(sunset_sky_color, elapsed_time / (Main.sun.time_of_sunset_sec - Main.sun.time_of_evening_sec))
		Main.sun.DAY_PHASES.NIGHTTIME:
			lerp_color = lerp_color.lerp(nightime_sky_color, elapsed_time / (Main.sun.time_of_sundown_sec - Main.sun.time_of_sunset_sec))
	
	environment.sky.sky_material.sky_top_color = lerp_color


func _on_day_phase_changed() -> void:
	elapsed_time = 0.0