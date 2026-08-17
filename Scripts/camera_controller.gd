class_name CameraController
extends Node3D


@onready var yaw_controller: Node3D = %YawController
@onready var pitch_controller: Node3D = %PitchController
var mouse_input: bool = false
var mouse_rotation: Vector3
var yaw_rotation_input: float
var pitch_rotation_input: float
var player_rotation: Vector3
var camera_rotation: Vector3
var cam_owner: Node3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()


func _process(_delta: float) -> void:
	if cam_owner:
		global_position = cam_owner.cam_anchor.global_position


func _unhandled_input(_event: InputEvent) -> void:
	pass
