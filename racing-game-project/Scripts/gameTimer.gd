extends Label

var gameTime = 20

@export var intro: Node3D

func _process(delta: float) -> void:
	if intro.startTimer <= 1:
		gameTime -= delta
		text = str(snapped(gameTime, 0))
		
		if gameTime < 0:
			get_tree().change_scene_to_file("res://Scenes/lose.tscn")
