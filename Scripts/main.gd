extends Node


@onready var player: CharacterBody3D = %Player
@onready var cam_controller: Node3D = %CameraController


func _ready() -> void:
	cam_controller.cam_owner = player
	cam_controller.global_position = player.cam_anchor.global_position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta: float) -> void:
	pass
