extends GPUParticles3D

@export var camera: Node3D

func _process(delta: float) -> void:
	global_position = camera.global_position
