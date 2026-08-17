class_name PlayerCharacter
extends CharacterBody3D


#region: Player Variables

## Movement Vars ##
@export var ground_speed: float = 5.0
@export var ground_accel: float = 15.0
@export var ground_deccel: float = 13.0
@export var air_speed: float = 5.0
@export var air_accel: float = 8.0
@export var air_deccel: float = 1.0
@export var turn_speed: float = 5.0
@export var jump_velocity: float = 4.5

## Camera-related Vars ##
@onready var cam_anchor: Marker3D = %CamAnchor
var cam_transform_y: float = 0.0
var cam_controller: CameraController = null

## Simple State Machine Vars ##
enum PLAYER_STATE {WALKING, JUMPING, FALLING, INTERACTING}
var current_state: PLAYER_STATE = PLAYER_STATE.WALKING

#endregion


func _ready() -> void:
	Main.player = self
	if Main.cam_controller and Main.player:
		Main.change_cam_ownership(Main.player)


func _input(event: InputEvent) -> void:
	if !cam_controller: return

	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y += jump_velocity
		_change_state(PLAYER_STATE.JUMPING)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	if !cam_controller: return

	_process_state(delta)

	move_and_slide()


func _apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func _process_state(delta: float) -> void:
	match current_state:
		PLAYER_STATE.WALKING:
			_handle_movement(delta)

		PLAYER_STATE.JUMPING:
			_handle_movement(delta)
			if velocity.y <= 0.0:
				_change_state(PLAYER_STATE.FALLING)

		PLAYER_STATE.FALLING:
			_handle_movement(delta)
			if is_on_floor():
				_change_state(PLAYER_STATE.WALKING)

		PLAYER_STATE.INTERACTING:
			pass


func _change_state(new_state: PLAYER_STATE) -> void:
	current_state = new_state


func _handle_movement(delta: float) -> void:
	var movement_speed: float = 0.0
	var movement_accel: float = 0.0
	var movement_deccel: float = 0.0

	match current_state:
		PLAYER_STATE.WALKING:
			movement_speed = ground_speed
			movement_accel = ground_accel
			movement_deccel = ground_deccel
		PLAYER_STATE.JUMPING, PLAYER_STATE.FALLING:
			movement_speed = air_speed
			movement_accel = air_accel
			movement_deccel = air_deccel
	
	cam_transform_y = Main.cam_controller.yaw_controller.global_transform.basis.get_euler().y

	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_dir: Vector3 = Vector3(input.x, 0.0, input.y)
	var forward_dir: Vector3 = input_dir.rotated(Vector3.UP, cam_transform_y).normalized()
	var precalculated_velocity: Vector2 = Vector2(velocity.x, velocity.z)

	if forward_dir:
		precalculated_velocity = precalculated_velocity.move_toward(Vector2(forward_dir.x, forward_dir.z) * movement_speed, movement_accel * delta)
		velocity.x = precalculated_velocity.x
		velocity.z = precalculated_velocity.y
	else:
		precalculated_velocity = precalculated_velocity.move_toward(Vector2.ZERO, movement_deccel * delta)
		velocity.x = precalculated_velocity.x
		velocity.z = precalculated_velocity.y
	
	if forward_dir != Vector3.ZERO:
		rotation.y = lerp_angle(rotation.y, atan2(-forward_dir.x, -forward_dir.z), turn_speed * delta)
