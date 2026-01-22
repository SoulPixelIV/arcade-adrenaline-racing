extends VehicleBody3D

@export var MAX_STEER = 0.35
@export var ENGINE_POWER = 1600
@export var MAX_SPEED = 11.5
@export var ENGINE_BRAKE = 65.0

var gamePlace = 0
var gameScore = 0
var currCheckpoint = 0

@onready var wheel_fl: VehicleWheel3D = $VehicleWheel3DFL
@onready var wheel_fr: VehicleWheel3D = $VehicleWheel3DFR
@onready var wheel_bl: VehicleWheel3D = $VehicleWheel3DBL
@onready var wheel_br: VehicleWheel3D = $VehicleWheel3DBR

@export var timer: Label
@export var score: Label
@export var place: Label
@export var enemy: Node3D
@export var gas: Array[Node3D]
@export var gasBig: Array[Node3D]
@export var lockzone: Node3D
@export var checkpoints: Array[Node3D]

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
	
	#Clamp Max Speed
	if speed > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
		
	#Stop car from moving on its own
	if input == 0:
		brake = 2
		
	#Entering Lock Zone
	var lockzoneArea = null
	if is_instance_valid(lockzone):
		lockzoneArea = lockzone.get_node_or_null("Area3D")
	if lockzoneArea:
		if lockzoneArea.get_overlapping_bodies().has(self):
			angular_velocity = Vector3(0,0,0)
				
		
	#Picking up Gas
	for gasPickup in gas:
		var area = null
		if is_instance_valid(gasPickup):
			area = gasPickup.get_node_or_null("jerrycan_grp_low/jerrycan_geo_low/Area3D")
		if area:
			if area.get_overlapping_bodies().has(self):
				timer.gameTime += 2
				gameScore += 2500
				gasPickup.queue_free()
				break
				
	for gasPickupBig in gasBig:
		var area2 = null
		if is_instance_valid(gasPickupBig):
			area2 = gasPickupBig.get_node_or_null("jerrycan_grp_low/jerrycan_geo_low/Area3D")
		if area2:
			if area2.get_overlapping_bodies().has(self):
				timer.gameTime += 10
				gameScore += 15000
				gasPickupBig.queue_free()
				
	#Score
	score.text = "Score: " + str(gameScore)
	
	#Place
	place.text = str(gamePlace) + "/2"
	
	if currCheckpoint >= checkpoints.size():
		return
	
	var distToCheckpoint = checkpoints[currCheckpoint].global_position - global_position
	var enemyDistToCheckpoint = checkpoints[currCheckpoint].global_position - enemy.global_position
	if distToCheckpoint.length() < 3 || enemyDistToCheckpoint.length() < 3:
		currCheckpoint += 1
	
	if distToCheckpoint.length() <= enemyDistToCheckpoint.length():
		gamePlace = 1
	else:
		gamePlace = 2
