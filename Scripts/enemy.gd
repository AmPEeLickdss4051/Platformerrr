extends CharacterBody3D


@onready var skin = $skin
@onready var player = $"../Player"

const SPEED = 5.0

var is_look: bool = false

func _physics_process(delta):
	#print(is_look)
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_look:
		self.look_at(player.global_position, Vector3.UP)
		
	var direction := (transform.basis * Vector3()).normalized()
	move_and_slide()


func _on_area_3d_body_entered(body):
	is_look = true

func _on_area_3d_body_exited(body):
	is_look = false
