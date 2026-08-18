extends Node


var player: PlayerCharacter = null
var cam_controller: CameraController = null
var cam_owner: Node3D = null
var sun: Sun = null
var atmosphere: Atmosphere = null


func _ready() -> void:
	pass
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_toggle_mouse_mode_captured"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func change_cam_ownership(new_owner: Node3D) -> void:
	cam_owner = new_owner
	cam_owner.cam_controller = cam_controller
	cam_controller.cam_owner = cam_owner
