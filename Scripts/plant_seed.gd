class_name PlantSeed
extends Node3D


## Class vars ##
# idk yet

## Floating Animation vars ##
@onready var starting_pos: Vector3 = get_global_position()
@export var amplitude: float = 40.0
@export var frequency: float = 3.0
@export var rotation_speed: float = 2.0
var time: float = 0.0
var wavelength_completed: bool = false


func _process(delta: float) -> void:
	if time > frequency and !wavelength_completed:
		wavelength_completed = true
	elif time <= frequency and wavelength_completed:
		wavelength_completed = false
	if wavelength_completed:
		time = 0.0
	else:
		time += delta
	var offset: float = cos(time * frequency) * amplitude
	global_position.y = starting_pos.y + offset * delta
	rotate(Vector3.UP, rotation_speed * delta)
