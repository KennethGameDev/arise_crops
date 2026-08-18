
class_name Atmosphere
extends WorldEnvironment


@export var daytime_sky_color: Color = Color.DEEP_SKY_BLUE
@export var nightime_sky_color: Color = Color.BLACK
var lerp_color: Color = daytime_sky_color

enum DAY_PHASES {SUNRISE, DAYTIME, SUNSET, NIGHTTIME}
var current_day_phase: DAY_PHASES = DAY_PHASES.SUNRISE


func _ready() -> void:
	Main.atmosphere = self


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_set_time_sunrise"):
		lerp_color = daytime_sky_color
	
	if event.is_action_pressed("DEBUG_set_time_sunset"):
		lerp_color = nightime_sky_color


func _process(delta: float) -> void:
	# lerp_color = lerp_color.lerp(nightime_sky_color, delta)
	# environment.sky.sky_material.set_sky_top_color(lerp_color)

	if lerp_color.is_equal_approx(daytime_sky_color):
		current_day_phase = DAY_PHASES.DAYTIME

	match current_day_phase:
		DAY_PHASES.SUNRISE:
			pass
			
		DAY_PHASES.DAYTIME:
			pass

		DAY_PHASES.SUNSET:
			pass

		DAY_PHASES.NIGHTTIME:
			pass
