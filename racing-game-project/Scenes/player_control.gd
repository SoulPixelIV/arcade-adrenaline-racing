extends Node3D

@export var player: Node3D

func _process(delta: float) -> void:
	print("CONTROL POSITION: " + str(player.global_position))
