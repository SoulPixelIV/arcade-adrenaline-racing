extends VehicleBody3D

@export var MAX_STEER = 0.4
@export var ENGINE_POWER = 162
@export var MAX_SPEED = 3.7
@export var ENGINE_BRAKE = 65.0

@onready var wheel_fl: VehicleWheel3D = $VehicleWheelFrontLeft
@onready var wheel_fr: VehicleWheel3D = $VehicleWheelFrontRight
@onready var wheel_bl: VehicleWheel3D = $VehicleWheelBackLeft
@onready var wheel_br: VehicleWheel3D = $VehicleWheelBackRight

@export var AIR_STABILIZE_STRENGTH := 8.0
@export var AIR_DAMPING := 4.0

func _physics_process(delta: float) -> void:
	var input := Input.get_axis("Break", "Gas")
	var speed := linear_velocity.length()
	var steerValue = Input.get_axis("Right", "Left") * MAX_STEER
	
	#Check Grounded
	var grounded := (wheel_fl.is_in_contact() or
					 wheel_fr.is_in_contact() or
					 wheel_bl.is_in_contact() or
					 wheel_br.is_in_contact()
	)
	
	#Steering
	if grounded:
		if sign(steerValue) != sign(steering):
			steering = steerValue
		else:
			steering = move_toward(steering, steerValue, delta * 2.5)
	else:
		steering = move_toward(steering, 0.0, delta * 5.0)
	
	#Forward & Backward
	if grounded:
		if input != 0:
			engine_force = Input.get_axis("Break", "Gas") * ENGINE_POWER
		else:
			engine_force = sign(speed) * ENGINE_BRAKE
	else:
		engine_force = 0
	
	#Clamp Max Speed
	if speed > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
	
	
