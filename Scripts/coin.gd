extends Area3D

@onready var particl: GPUParticles3D = $GPUParticles3D

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		particl.emitting = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + Vector3(0, 0.3, 0), 0.5)
		tween.tween_callback(queue_free)
		body.coin += 1
