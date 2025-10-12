extends State

@onready var player = $"../.."
@onready var camera: Camera3D = $"../../SpringArm3D/Camera3D"


func physics_update(_delta: float) -> void:
	if player.direction == Vector3.ZERO:
		state_machine.change_state("Idle")
		
	if Input.is_action_just_pressed("JUMP"):
		state_machine.change_state("Jump")
		
	if Input.is_action_just_pressed("JUMP") and player.doubleJumpActivated == true:
		state_machine.change_state("DoubleJump")
		
	if Input.is_action_just_pressed("Acceleration"):
		state_machine.change_state("Acceleration")
	
	player.move()
	player.move_and_slide()
