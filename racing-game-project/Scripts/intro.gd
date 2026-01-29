extends Node

@export var startTimerText: Label

var startTimer = 6.0
var goTimer = 2.0

func _ready() -> void:
	startTimerText.text = ""

func _process(delta: float) -> void:
	if goTimer > 0:
		startTimer -= delta / 1.5
		
		if startTimer <= 6 && startTimer > 1:
			startTimerText.text = str(snapped(startTimer, 0))
		if startTimer <= 1:
			startTimerText.text = ("GO!!!")
			goTimer -= delta / 1.75
	else:
		startTimerText.text = ""
	
