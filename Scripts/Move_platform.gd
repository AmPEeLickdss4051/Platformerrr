extends Path3D

@onready var path: PathFollow3D = $PathFollow3D
@onready var platform: AnimatableBody3D = $PathFollow3D/AnimatableBody3D

@export var speed: float = 1.0

func _process(delta: float) -> void:
	path.progress += speed * delta
	platform.rotation = Vector3.ZERO
	platform.position = Vector3.ZERO
	
