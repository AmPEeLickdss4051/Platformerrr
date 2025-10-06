extends Label

@onready var player = $"../../../.."

func _process(delta):
	text = "GOLD: " + str(player.coin)
