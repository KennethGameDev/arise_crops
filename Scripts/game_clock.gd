extends Control


## Clock Vars
@onready var clock_label: Label = %Clock
var clock_text: String = "00:00"
var military_time: bool = true

## Day Progress Bar Vars
@onready var day_progress_bar: ProgressBar = %DayProgress
var daytime_percentage: float = 0.0


func _process(_delta: float) -> void:
	_update_clock_label()

	_update_day_progress_bar()


func _update_clock_label() -> void:
	if military_time:
		clock_text = GameMaster.sky.game_time.substr(0, 5)
	else:
		if GameMaster.sky.current_time < 1.0:
			clock_text = "12" + GameMaster.sky.game_time.substr(2, 3) + " am"
		elif GameMaster.sky.current_time < 12.0:
			clock_text = GameMaster.sky.game_time.substr(0, 5) + " am"
		elif GameMaster.sky.current_time < 13.0:
			clock_text = GameMaster.sky.game_time.substr(0, 5) + " pm"
		elif GameMaster.sky.current_time < 22.0:
			clock_text = "0" + str(GameMaster.sky.game_time.substr(0, 2).to_int() - 12) + GameMaster.sky.game_time.substr(2, 3) + " pm"
		else:
			clock_text = str(GameMaster.sky.game_time.substr(0, 2).to_int() - 12) + GameMaster.sky.game_time.substr(2, 3) + " pm"
	
	clock_label.text = clock_text


func _update_day_progress_bar() -> void:
	if GameMaster.sky.current_time >= GameMaster.wake_up_time_hour and GameMaster.sky.current_time <= 17.75:
		daytime_percentage = (GameMaster.sky.current_time - GameMaster.wake_up_time_hour) / (17.75 - GameMaster.wake_up_time_hour)

	day_progress_bar.value = daytime_percentage
