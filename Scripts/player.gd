extends CharacterBody3D


#region: Player Variables

## Movement Vars ##
@export var ground_speed: float = 5.0
@export var ground_accel: float = 2.0
@export var air_speed: float = 2.0
@export var air_accel: float = 1.0
@export var turn_speed: float = 5.0
@export var jump_velocity: float = 4.5

## Camera-related Vars ##
@onready var cam_anchor: Marker3D = %CamAnchor
var cam_transform_y: float = 0.0
var current_cam_controller: CameraController = null

## Simple State Machine Vars ##
enum PLAYER_STATE {WALKING, JUMPING, FALLING, INTERACTING}
var current_state: PLAYER_STATE = PLAYER_STATE.WALKING

#endregion


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		velocity.y += jump_velocity
		_change_state(PLAYER_STATE.JUMPING)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_process_state()

	# # Get the input direction and handle the movement/deceleration.
	# # As good practice, you should replace UI actions with custom gameplay actions.
	# var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	# var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	move_and_slide()


func _apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func _process_state() -> void:
	match current_state:
		PLAYER_STATE.WALKING:
			_handle_ground_movement()

		PLAYER_STATE.JUMPING:
			_handle_air_movement()
			if velocity.y <= 0.0:
				_change_state(PLAYER_STATE.FALLING)

		PLAYER_STATE.FALLING:
			_handle_air_movement()
			if is_on_floor():
				_change_state(PLAYER_STATE.WALKING)

		PLAYER_STATE.INTERACTING:
			pass


func _change_state(new_state: PLAYER_STATE) -> void:
	current_state = new_state


func _handle_ground_movement() -> void:
	pass


func _handle_air_movement() -> void:
	pass


func _handle_movement() -> void:
	var movement_speed: float = 0.0
	var movement_accel: float = 0.0

	match current_state:
		PLAYER_STATE.WALKING:
			movement_speed = ground_speed
			movement_accel = ground_accel
		PLAYER_STATE.JUMPING | PLAYER_STATE.FALLING:
			movement_speed = air_speed
			movement_accel = air_accel
	
	# cam_transform_y is set from the camera_controller script


func attatch_camera_controller(new_camera_controller: CameraController) -> void:
	current_cam_controller = new_camera_controller


func detatch_camera_controller() -> void:
	current_cam_controller = null
