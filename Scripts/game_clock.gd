extends Control


@onready var clock_label: Label = %Clock
@onready var day_progress: ProgressBar = %DayProgress
var time_of_day_display_hour: int = 0
var time_of_day_display_min: int = 0
var day_completion_percentage: float = 0.0
var morning_start_time: int = 6
var is_morning: bool = true
var military_time: bool = true


func _process(_delta: float) -> void:
	clock_label.text = format_time_text()
	update_day_progress_bar()


func format_time_text() -> String:
	var result: String = "00:00am"

	time_of_day_display_min = int(Main.sun.current_time_of_day) % 60
	time_of_day_display_hour = int(Main.sun.current_time_of_day / 60.0) + morning_start_time

	var minutes_string: String
	if time_of_day_display_min < 10:
		minutes_string = "0%s" % time_of_day_display_min
	else: minutes_string = str(time_of_day_display_min)

	var hours_string: String
	if !military_time and time_of_day_display_hour > 11 and is_morning:
		is_morning = false
	if time_of_day_display_hour > 12 and !military_time:
		time_of_day_display_hour -= 12
	if time_of_day_display_hour < 10:
		hours_string = "0%s" % time_of_day_display_hour
	else: hours_string = str(time_of_day_display_hour)

	if military_time:
		result = hours_string + ":" + minutes_string
	elif is_morning:
		result = hours_string + ":" + minutes_string + "am"
	else:
		result = hours_string + ":" + minutes_string + "pm"

	return result


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_toggle_military_time"):
		military_time = !military_time


func update_day_progress_bar() -> void:
	day_progress.value = Main.sun.current_time_of_day / Main.sun.time_of_night_end_sec
