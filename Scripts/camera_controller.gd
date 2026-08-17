class_name CameraController
extends Node3D


@onready var yaw_controller: Node3D = %YawController
@onready var pitch_controller: Node3D = %PitchController
@export var mouse_sens: float = 0.005
var input_rotation: Vector3
var mouse_input: Vector2
var cam_owner: Node3D


func _ready() -> void:
	Main.cam_controller = self
	if Main.cam_controller and Main.player:
		Main.change_cam_ownership(Main.player)


func _input(event: InputEvent) -> void:
	if !cam_owner: return

	if event is InputEventMouseMotion and Input.get_mouse_mode() != 0:
		mouse_input.x += -event.relative.x * mouse_sens
		mouse_input.y += -event.relative.y * mouse_sens


func _process(_delta: float) -> void:
	if !cam_owner: return
	
	input_rotation.x = clampf(input_rotation.x + mouse_input.y, deg_to_rad(-90), deg_to_rad(85))
	input_rotation.y += mouse_input.x

	yaw_controller.global_rotation.y = input_rotation.y
	pitch_controller.global_rotation.x = input_rotation.x

	global_position = cam_owner.cam_anchor.global_position

	mouse_input = Vector2.ZERO
