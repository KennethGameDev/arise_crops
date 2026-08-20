extends Node3D


@onready var starting_pos: Vector3 = get_global_position()
var amplitude: float = 40.0
var frequency: float = 3.0
var rotation_speed: float = 2.0
var time: float = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var offset: float = cos(time * frequency) * amplitude
	global_position.y = starting_pos.y + offset * delta
	rotate(Vector3.UP, rotation_speed * delta)
