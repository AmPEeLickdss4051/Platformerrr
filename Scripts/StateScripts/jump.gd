extends State

@onready var player = $"../.."

func physics_update(_delta: float) -> void:
	if player.direction == Vector3.ZERO:
		state_machine.change_state("Idle")
		print(state_machine.current_state)
		
	if player.direction != Vector3.ZERO:
		state_machine.change_state("Move")
		print(state_machine.current_state)
	
	player.jump()
	player.move_and_slide()
