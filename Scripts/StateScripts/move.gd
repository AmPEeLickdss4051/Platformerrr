extends State

@onready var player = $"../.."

func physics_update(_delta: float) -> void:
	if player.direction == Vector3.ZERO:
		state_machine.change_state("Idle")
		print(state_machine.current_state)
		
	if Input.is_action_just_pressed("JUMP") and player.is_on_floor():
		state_machine.change_state("Jump")
		print(state_machine.current_state)
		
	if Input.is_action_just_pressed("JUMP") and player.doubleJumpActivated == true and not player.is_on_floor():
		state_machine.change_state("DoubleJump")
		print(state_machine.current_state)
		
	if Input.is_action_just_pressed("Acceleration") and player.is_on_floor():
		state_machine.change_state("Acceleration")
		print(state_machine.current_state)
	
	
	player.move()
	player.move_and_slide()
