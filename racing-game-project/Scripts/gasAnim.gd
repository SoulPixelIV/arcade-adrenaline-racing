extends Node3D

@export var amplitude: float = 0.05   # Höhe der Bewegung
@export var speed: float = 2.0       # Geschwindigkeit der Bewegung

var base_y: float = 0.0
var time_passed: float = 0.0

func _ready():
	# Ausgangsposition speichern
	base_y = global_position.y

func _process(delta: float):
	time_passed += delta * speed
	global_position.y = base_y + sin(time_passed) * amplitude
	global_rotation.y += delta
