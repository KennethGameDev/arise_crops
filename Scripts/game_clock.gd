extends Control


var time_of_day_display_hour: int = 0
var time_of_day_display_min: int = 0


func _process(delta: float) -> void:
	print(calc_hours_display(), ":", calc_minutes_display())
	pass


func calc_hours_display() -> int:
	var result: int = 0

	time_of_day_display_hour = int(Main.sun.current_time_of_day / 60)
	print(Main.sun.current_time_of_day)

	return result


func calc_minutes_display() -> int:
	var result: int = 0

	# print(Main.sun.current_time_of_day / 10)
	time_of_day_display_min = int(((Main.sun.current_time_of_day - int(Main.sun.current_time_of_day)) * 100) / 60)

	return result


func format_time_text() -> String:
	var result: String = "00:00"



	return result
