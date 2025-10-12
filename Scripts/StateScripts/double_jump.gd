extends State

@onready var player = $"../.."

func physics_update(_delta: float) -> void:
	if player.direction == Vector3.ZERO:
		state_machine.change_state("Idle")
		
	if player.direction != Vector3.ZERO:
		state_machine.change_state("Move")
		
	if Input.is_action_just_pressed("Acceleration"):
		state_machine.change_state("Acceleration")
	
	player.double_jump()
	player.move_and_slide()
