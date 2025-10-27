extends CharacterBody3D

@export var HEALTH = 100
@export var SPEED = 3.5
@export var JUMP_VELOCITY = 3.5
@export var JUMP_ACC = 3.8
@export var ACCELERATION = 4.0
@export var BLEND_SPEED = 15.0
@export var WALL_SPEED = 3.5
@export var WALL_GRAVITY = -0.5
@export var WALL_JUMP_FORCE = 3.5
@export var WALL_JUMP_VERTICAL_FORCE = 2.5

@onready var character: Node3D = $character
@onready var camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D
@onready var health_bar = $UI_Player/TextureProgressBar
@onready var animation_tree: AnimationTree = $character/AnimationTree

var direction = Vector3.ZERO
var wall_direction = Vector3.FORWARD
var wall_normal
var coin: int

var doubleJumpActivated = true
var can_Action = false
var is_WallJump = false


enum {IDLE, RUN, ACC}
var currentAnim = IDLE

func handle_anim(delta):
	match  currentAnim:
		IDLE:
			animation_tree.set("parameters/Movement/transition_request", "Idle")
		RUN:
			animation_tree.set("parameters/Movement/transition_request", "SlowRun")
		ACC:
			animation_tree.set("parameters/Movement/transition_request", "FastRun")
	
func _ready():
	Signals.Damage.connect(death)

func death(hit):
	HEALTH -= hit
	health_bar.value = HEALTH
	if HEALTH <= 0:
		get_tree().quit()

func wall_collision():
	if get_slide_collision_count() > 0:
		var wall_collision = get_slide_collision(0)
		wall_normal = wall_collision.get_normal()
		print(wall_normal)
	
func _physics_process(delta: float) -> void:
	handle_anim(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		doubleJumpActivated = true
	
	var input_dir := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y).normalized()
	
	var wall_direction = Input.is_action_just_pressed("UP")
	
	if Input.is_action_just_pressed("Pause") or coin == 5:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		get_tree().change_scene_to_file("res://Scenes/mainmanu.tscn")
	
	if Input.is_action_just_pressed("Apply") and can_Action == true and not is_on_floor():
		velocity.y = JUMP_VELOCITY
		doubleJumpActivated = true

func idle():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)
	currentAnim = IDLE

func move():
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		currentAnim = RUN
		
		var target_angel = atan2(direction.x, direction.z)
		var current_angel = character.global_rotation.y
		character.global_rotation.y = lerp_angle(current_angel, target_angel, 0.3)
	
func acceleration():
	if direction != Vector3.ZERO:
		velocity.x = direction.x * ACCELERATION
		velocity.z = direction.z * ACCELERATION
		currentAnim = ACC
		
		var target_angel = atan2(direction.x, direction.z)
		var current_angel = character.global_rotation.y
		character.global_rotation.y = lerp_angle(current_angel, target_angel, 0.2)
	
func jump():
	velocity.y = JUMP_VELOCITY
	animation_tree.set("parameters/JUMP/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func jump_acc():
	velocity.y = JUMP_ACC
	velocity.x = direction.x * ACCELERATION
	velocity.z = direction.z * ACCELERATION
	animation_tree.set("parameters/JUMP/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func double_jump():
	velocity.y = JUMP_VELOCITY
	doubleJumpActivated = false
	animation_tree.set("parameters/JUMP/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func wall_slide():
	velocity.y = WALL_GRAVITY
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)

func wall_jump():
	wall_collision()
	var wall_jump_force = wall_normal * WALL_JUMP_FORCE
	var wall_tangent = Vector3(wall_normal.z, 0, -wall_normal.x).normalized()
	var tangent_velocity = wall_tangent * velocity.dot(wall_tangent)
	velocity = tangent_velocity + wall_jump_force
	velocity.y = WALL_JUMP_VERTICAL_FORCE
	
func wall_run():
	pass
	#if get_slide_collision_count() > 0:
		#var wall_collision = get_slide_collision(0)
		#wall_normal = wall_collision.get_normal()
		#velocity.y = WALL_GRAVITY
		#var wall_tangent = Vector3(wall_normal.z, 0, -wall_normal.x).normalized()
		#var dot_forward = direction.dot(-wall_tangent)
		#var dot_backward = direction.dot(wall_tangent)
		#if abs(dot_forward) > abs(dot_backward):
			#wall_direction = -wall_tangent * WALL_SPEED * sign(dot_forward)
		#else:
			#wall_direction = wall_tangent * WALL_SPEED * sign(dot_backward)
		#
		#velocity.x = wall_direction.x
		#velocity.z = wall_direction.z
		#
		#if wall_direction.length() > 0.1:
			#var target_angle = atan2(wall_direction.x, wall_direction.z)
			#var current_angle = character.global_rotation.y
			#character.global_rotation.y = lerp_angle(current_angle, target_angle, 0.3)

func _on_area_3d_area_entered(area: Area3D) -> void:
	can_Action = true
func _on_area_3d_area_exited(area: Area3D) -> void:
	can_Action = false


func _on_body_wall_jump_entered(body: Node3D) -> void:
	is_WallJump = true
func _on_body_wall_jump_exited(body: Node3D) -> void:
	is_WallJump = false
