extends VehicleBody3D

@export var MAX_STEER = 0.35
@export var ENGINE_POWER = 1600
@export var MAX_SPEED = 11.5
@export var ENGINE_BRAKE = 65.0

@onready var wheel_fl: VehicleWheel3D = $VehicleWheel3DFL
@onready var wheel_fr: VehicleWheel3D = $VehicleWheel3DFR
@onready var wheel_bl: VehicleWheel3D = $VehicleWheel3DBL
@onready var wheel_br: VehicleWheel3D = $VehicleWheel3DBR

@export var timer: Label
@export var gas: Array[Node3D]
@export var gasBig: Array[Node3D]

var grounded = false

func _physics_process(delta: float) -> void:
	var input := Input.get_axis("Break", "Gas")
	var speed := linear_velocity.length()
	var steerValue = Input.get_axis("Right", "Left") * MAX_STEER
	
	#Check Grounded
	if wheel_fl.is_in_contact() and wheel_fr.is_in_contact() and wheel_bl.is_in_contact() and wheel_br.is_in_contact():
		grounded = true
	else:
		grounded = false
	
	#Steering
	if steerValue != 0:
		steering = move_toward(steering, steerValue, delta * 10)
	else:
		steering = move_toward(steering, 0.0, delta * 5.0)
	
	#Forward & Backward
	if input != 0:
		engine_force = Input.get_axis("Break", "Gas") * ENGINE_POWER
	else:
		engine_force = sign(speed) * ENGINE_BRAKE
	
	#if not grounded:
		#angular_velocity = Vector3(0,0,0)
	
	#Clamp Max Speed
	if speed > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
		
	#Stop car from moving on its own
	if input == 0:
		brake = 2
		
	#Picking up Gas
	for gasPickup in gas:
		var area = null
		if is_instance_valid(gasPickup):
			area = gasPickup.get_node_or_null("jerrycan_grp_low/jerrycan_geo_low/Area3D")
		if area:
			if area.get_overlapping_bodies().has(self):
				timer.gameTime += 2
				gasPickup.queue_free()
				break
				
	for gasPickupBig in gasBig:
		var area2 = null
		if is_instance_valid(gasPickupBig):
			area2 = gasPickupBig.get_node_or_null("jerrycan_grp_low/jerrycan_geo_low/Area3D")
		if area2:
			if area2.get_overlapping_bodies().has(self):
				timer.gameTime += 10
				gasPickupBig.queue_free()
				
