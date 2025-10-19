extends Label


@onready var player: CharacterBody3D = $"../.."

func _process(delta):
	text = "GOLD: " + str(player.coin)
