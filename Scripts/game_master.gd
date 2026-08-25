extends Node


var player: PlayerCharacter = null
var sky: Sky3D = null
var game_ready: bool = false
var wake_up_time_hour: float = 7.0


func _ready() -> void:
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func _process(_delta: float) -> void:
	if player and sky and !game_ready:
		game_ready = true
		wake_up(wake_up_time_hour)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_toggle_mouse_mode_captured"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func wake_up(time_to_wake_up_hour: float) -> void:
	if time_to_wake_up_hour < 0.0:
		time_to_wake_up_hour = 0.0
	elif time_to_wake_up_hour > 12.0:
		time_to_wake_up_hour = 12.0
	
	wake_up_time_hour = time_to_wake_up_hour
	sky.current_time = time_to_wake_up_hour
