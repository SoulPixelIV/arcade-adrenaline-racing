extends VehicleBody3D

@export var MAX_STEER = 0.35
@export var ENGINE_POWER = 1600
@export var MAX_SPEED = 11.5
@export var ENGINE_BRAKE = 65.0

var gamePlace = 0
var gameScore = 0
var currCheckpoint = 0
var speedometerTimer = 3

@onready var wheel_fl: VehicleWheel3D = $VehicleWheel3DFL
@onready var wheel_fr: VehicleWheel3D = $VehicleWheel3DFR
@onready var wheel_bl: VehicleWheel3D = $VehicleWheel3DBL
@onready var wheel_br: VehicleWheel3D = $VehicleWheel3DBR
@onready var engine_sound = $EngineSound
@onready var pickup_sound = $PickupSound

@export var timer: Label
@export var score: Label
@export var place: Label
@export var speedometer: Label
@export var enemies: Array[Node3D]
@export var gas: Array[Node3D]
@export var gasBig: Array[Node3D]
@export var lockzone: Node3D
@export var checkpoints: Array[Node3D]
@export var intro: Node3D
@export var finishLine: Node3D
@export var checkpoint1: Node3D
@export var checkpoint2: Node3D
@export var camera: Node3D

var passedCheckpoint1 = false;
var passedCheckpoint2 = false;

var grounded = false

func _physics_process(delta: float) -> void:
	var speed := linear_velocity.length()
	
	if intro.startTimer <= 1:
		var input := Input.get_axis("Break", "Gas")
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
					pickup_sound.play()
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
					pickup_sound.play()
					timer.gameTime += 10
					gameScore += 15000
					gasPickupBig.queue_free()
					
		#Score
		score.text = "Score: " + str(gameScore)
		
		#Place
		place.text = str(gamePlace) + "/4"
		
		#Speedometer
		speedometerTimer -= delta * 45
		if speedometerTimer < 0:
			speedometer.text = str(snapped(speed * 15.6, 0))
			speedometerTimer = 3
		
		if currCheckpoint >= checkpoints.size():
			return
		
		var better_enemies := 0
		#Count Up Checkpoint
		var distToCheckpoint = checkpoints[currCheckpoint].global_position - camera.global_position
		if distToCheckpoint.length() < 10:
			if currCheckpoint < checkpoints.size() - 1:
				currCheckpoint += 1
		print("Distance to Checkpoint" + str(distToCheckpoint.length()))
		for e in enemies:
			if not is_instance_valid(e):
				continue
		
			###Check Checkpoint Count###
			#Is Enemy further then Player
			if e.currCheckpoint > currCheckpoint:
				better_enemies += 1
			#Is Enemy at same checkpoint as Player
			elif e.currCheckpoint == currCheckpoint:
				var enemyDistToCheckpoint = checkpoints[currCheckpoint].global_position - e.global_position
				#Is Enemy closer to next checkpoint
				distToCheckpoint = checkpoints[currCheckpoint].global_position - camera.global_position
				if enemyDistToCheckpoint.length() < distToCheckpoint.length():
					better_enemies += 1
		
		gamePlace = better_enemies + 1
		
		#Reaching Checkpoint1
		var checkpoint1Shape = null
		if is_instance_valid(checkpoint1):
			checkpoint1Shape = checkpoint1.get_node_or_null("Area3D")
		if checkpoint1Shape:
			if checkpoint1Shape.get_overlapping_bodies().has(self):
				passedCheckpoint1 = true
				
		#Reaching Checkpoint2
		var checkpoint2Shape = null
		if is_instance_valid(checkpoint2):
			checkpoint2Shape = checkpoint2.get_node_or_null("Area3D")
		if checkpoint2Shape:
			if checkpoint2Shape.get_overlapping_bodies().has(self):
				passedCheckpoint2 = true
				
		#Reaching the Finish
		var clShape = null
		if is_instance_valid(finishLine):
			clShape = finishLine.get_node_or_null("Area3D")
		if clShape:
			if clShape.get_overlapping_bodies().has(self):
				if passedCheckpoint1 && passedCheckpoint2:
					if gamePlace == 1:
						get_tree().change_scene_to_file("res://Scenes/win.tscn")
					else:
						get_tree().change_scene_to_file("res://Scenes/lose.tscn")
		
	#Sound
	var pitch = lerp(0.5, 1.5, speed / MAX_SPEED)
	engine_sound.pitch_scale = pitch
