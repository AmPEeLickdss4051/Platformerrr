extends Area3D

var damage = 25


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("enter")
		Signals.emit_signal("Damage", damage)
		body.global_position = Vector3(0, 1, 8)
