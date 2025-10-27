extends State

@onready var player = $"../.."

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("JUMP"):
		state_machine.change_state("WallJump")
		print(state_machine.current_state)
		
	if player.is_on_floor():
		state_machine.change_state("Idle")
		print(state_machine.current_state)
	
	player.wall_slide()
	player.move_and_slide()
