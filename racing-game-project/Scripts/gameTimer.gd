extends Label

var gameTime = 20

@export var intro: Node3D

func _process(delta: float) -> void:
	if intro.startTimer <= 1:
		gameTime -= delta
		text = str(snapped(gameTime, 0))
