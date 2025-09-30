extends AnimatableBody3D


var speed: float = 2.0
var moving_forward: bool = true
var start_z: float = 0.0
var end_z: float = 5.0

func _process(delta):
	if moving_forward:
		# Двигаем вперед
		position.z += speed * delta
		if position.z >= end_z:
			moving_forward = false  # Меняем направление
	else:
		# Двигаем назад
		position.z -= speed * delta
		if position.z <= start_z:
			moving_forward = true  # Меняем направление
