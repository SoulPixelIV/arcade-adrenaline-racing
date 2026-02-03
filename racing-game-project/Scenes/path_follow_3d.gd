extends PathFollow3D

func _ready():
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "progress_ratio", 1.0, 15.0)
	
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
