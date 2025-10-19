extends Node3D

@onready var spring_arm: SpringArm3D = $SpringArm3D


@export var Mouse_sens: float = 0.005

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * Mouse_sens
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		spring_arm.rotation.x -= event.relative.y * Mouse_sens
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/4)
