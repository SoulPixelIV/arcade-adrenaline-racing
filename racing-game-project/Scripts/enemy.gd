extends VehicleBody3D

@export var MAX_STEER = 0.35
@export var ENGINE_POWER = 1600
@export var MAX_SPEED = 11.5
@export var ENGINE_BRAKE = 65.0

@export var waypoints: Array[Node3D]
@export var slowdownZones: Array[Node3D]
@export var reach_distance := 3.0
@export var intro: Node3D

@onready var wheel_fl: VehicleWheel3D = $VehicleWheel3DFL
@onready var wheel_fr: VehicleWheel3D = $VehicleWheel3DFR
@onready var wheel_bl: VehicleWheel3D = $VehicleWheel3DBL
@onready var wheel_br: VehicleWheel3D = $VehicleWheel3DBR

var currCheckpoint = 0
@export var checkpoints: Array[Node3D]

var grounded = false
var in_slowzone = false
var current_wp := 0

func _physics_process(delta: float) -> void:
	if intro.startTimer <= 1:
		var speed := linear_velocity.length()
			
		#Check Grounded
		if wheel_fl.is_in_contact() and wheel_fr.is_in_contact() and wheel_bl.is_in_contact() and wheel_br.is_in_contact():
			grounded = true
		else:
			grounded = false
			
		#Waypoint
		var target = waypoints[current_wp].global_position
		var distance_to_target = target - global_position
			
		#Steering
		var to_target = (target - global_position)
		to_target.y = 0
		to_target = to_target.normalized()
		
		var forward = -global_transform.basis.z
		forward.y = 0
		forward = forward.normalized()
		
		var steer_amount = -forward.cross(to_target).y
		steering = move_toward(steering, steer_amount * MAX_STEER, delta * 5)
		
		#Slow Down
		for zone in slowdownZones:
			var area = zone.get_node_or_null("Area3D")
			if area:
				if area.get_overlapping_bodies().has(self):
					in_slowzone = true
					break
				else:
					in_slowzone = false
					
		if in_slowzone:
			engine_force = ENGINE_POWER / 2
			brake = ENGINE_BRAKE
		else:
			#Engine Force
			if distance_to_target.length() > 3 && speed < MAX_SPEED:
				engine_force = ENGINE_POWER
			brake = 0
		
		#Switch Waypoint
		if distance_to_target.length() < reach_distance:
			current_wp = (current_wp + 1) % waypoints.size()
			
		#Count Checkpoints
		if currCheckpoint >= checkpoints.size():
			return
		
		var distToCheckpoint = checkpoints[currCheckpoint].global_position - global_position
		if distToCheckpoint.length() < 3:
			if currCheckpoint < checkpoints.size() - 1:
				currCheckpoint += 1
