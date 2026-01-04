extends Node3D

@export var target: Node3D
var follow_speed := 5.0
var rotation_speed := 3.0

func _process(delta: float) -> void:
	if not target:
		return
		
	global_position = global_position.lerp(
		target.global_position,
		follow_speed * delta
	)
	
	global_rotation = global_rotation.lerp(
		target.global_rotation,
		rotation_speed * delta
	)
