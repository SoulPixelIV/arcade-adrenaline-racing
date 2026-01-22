extends Node3D

@export var player: Node3D

func _process(delta: float) -> void:
	global_position.x = player.global_position.x
	global_position.z = player.global_position.z
