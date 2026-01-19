extends Label

var gameTime = 20

func _process(delta: float) -> void:
	gameTime -= delta
	text = str(snapped(gameTime, 0))
