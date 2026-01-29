extends Node

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
	
func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
