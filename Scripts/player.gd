extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

@onready var skin: Node3D = $Skin
@onready var camera: Camera3D = $SpringArm3D/Camera3D

var coin: float

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	if direction != Vector3.ZERO:
		#move
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		#rotate
		var tar_position = global_position + direction
		var cur_rotation = skin.global_rotation
		skin.look_at(tar_position, Vector3.UP)
		skin.global_rotation.y = lerp_angle(cur_rotation.y, skin.global_rotation.y, 0.2)
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
		
	move_and_slide()
