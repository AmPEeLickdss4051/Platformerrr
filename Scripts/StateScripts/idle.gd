extends State

@onready var player = $"../.."

func physics_update(_delta: float) -> void:
	if player.direction != Vector3.ZERO:
		state_machine.change_state("Move")
		
	if Input.is_action_just_pressed("JUMP") and player.is_on_floor():
		state_machine.change_state("Jump")
		
	if Input.is_action_just_pressed("JUMP") and player.doubleJumpActivated == true and not player.is_on_floor():
		state_machine.change_state("DoubleJump")
	
	player.idle()
	player.move_and_slide()
