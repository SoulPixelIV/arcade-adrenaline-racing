extends Node3D

@export var player: Node3D
var passedCheckpoint = false

func _physics_process(delta: float) -> void:
	var distToPlayer = global_transform.origin - player.global_position
	if distToPlayer < 3:
		print("ENTERED")
