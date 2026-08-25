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
@onready var cam_controller: CameraController = %CamController
var cam_transform_y: float = 0.0

## Simple State Machine Vars ##
enum PLAYER_STATE {WALKING, JUMPING, FALLING}
var current_state: PLAYER_STATE = PLAYER_STATE.WALKING

## Planting Vars ##
var seed_inventory: Array[PlantSeed] = []

#endregion


#region: Core Functions

func _ready() -> void:
	GameMaster.player = self


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y += jump_velocity
		_change_state(PLAYER_STATE.JUMPING)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)

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
	
	cam_transform_y = cam_controller.yaw_controller.global_transform.basis.get_euler().y

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

#endregion


#region: Planting Functions

func add_seed_to_inventory(new_seed: PlantSeed) -> void:
	seed_inventory.append(new_seed)


func pop_seed_from_inventory() -> PlantSeed:
	return seed_inventory.pop_front()

#endregion


#region: Detection Functions
#endregion
