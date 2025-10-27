extends State

@onready var player = $"../.."

func physics_update(_delta: float) -> void:
	if player.is_on_wall():
		state_machine.change_state("WallSlide")
		print(state_machine.current_state)
		
	if Input.is_action_just_pressed("UP"):
		state_machine.change_state("Move")
		print(state_machine.current_state)
	
	player.wall_jump()
	player.move_and_slide()
