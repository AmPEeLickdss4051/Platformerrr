extends SpringArm3D

@export var Mouse_sens: float = 0.005



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * Mouse_sens
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event.relative.y * Mouse_sens
		rotation.x = clamp(rotation.x, -PI/2, PI/4)
