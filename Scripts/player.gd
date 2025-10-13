extends CharacterBody3D

@export var HEALTH = 100
@export var SPEED = 3.0
@export var JUMP_VELOCITY = 3.5
@export var ACCELERATION = 4.0

@onready var skin: Node3D = $Skin
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var health_bar = $SpringArm3D/Camera3D/UI_Player/TextureProgressBar

var direction := Vector3.ZERO
var coin: int
var doubleJumpActivated = true
var Action = false

func _ready():
	Signals.Damage.connect(death)

func death(hit):
	HEALTH -= hit
	health_bar.value = HEALTH
	if HEALTH <= 0:
		get_tree().quit()
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		doubleJumpActivated = true
	
	var input_dir := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	
	if Input.is_action_just_pressed("Pause") or coin == 5:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		get_tree().change_scene_to_file("res://Scenes/mainmanu.tscn")
		
	if Input.is_action_just_pressed("Apply"):
		Action = true
		print(Action)
	if Input.is_action_just_released("Apply"):
		Action = false
		print(Action)

func idle():
	pass

func move():
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		var tar_position = global_position + direction
		var cur_rotation = skin.global_rotation
		skin.look_at(tar_position, Vector3.UP)
		skin.global_rotation.y = lerp_angle(cur_rotation.y, skin.global_rotation.y, 0.2)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
func jump():
	velocity.y = JUMP_VELOCITY

func double_jump():
	velocity.y = JUMP_VELOCITY
	doubleJumpActivated = false

func acceleration():
	if direction != Vector3.ZERO:
		velocity.x = direction.x * ACCELERATION
		velocity.z = direction.z * ACCELERATION
		var tar_position = global_position + direction
		var cur_rotation = skin.global_rotation
		skin.look_at(tar_position, Vector3.UP)
		skin.global_rotation.y = lerp_angle(cur_rotation.y, skin.global_rotation.y, 0.2)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION)


func _on_area_3d_body_entered(body):
	if Action == true:
		velocity.y = JUMP_VELOCITY
