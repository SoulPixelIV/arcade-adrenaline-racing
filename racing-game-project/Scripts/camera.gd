extends Node3D

@export var target: Node3D
var distance := 1.6
var height := 0.9
var lookOffset = 0.5

func _process(delta: float) -> void:
	if not target:
		return
		
	var offset = -target.global_transform.basis.z * distance
	offset.y += height
	var desired_position = target.global_position + offset
	
	global_position = desired_position
	
	var look_target = target.global_position + Vector3.UP * lookOffset
	var desired_transform = global_transform.looking_at(look_target, Vector3.UP)

	global_rotation = desired_transform.basis.get_euler()
