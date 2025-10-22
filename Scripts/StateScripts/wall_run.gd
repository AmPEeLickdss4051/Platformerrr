extends State

@onready var player = $"../.."

func physics_update(_delta: float) -> void:
	#if player.direction == Vector3.ZERO:
		#state_machine.change_state("Idle")
		#print(state_machine.current_state)
	
	if not player.is_on_wall():
		state_machine.change_state("Idle")
	
	player.wall_run()
	player.move_and_slide()
