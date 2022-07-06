extends KinematicBody2D
class_name Player

"""
Main Player Class

uses Energy to jump
apples collected count increases energy regeneration rate
cherrys increase jumping force
"""

#Define Custom Signals
signal health_updated(Player)
signal energy_updated(Player)
signal killed()

#Constant Properties
const UP = Vector2(0,-1)
const GRAVITY = 12
const MAXFALLSPEED = 250
const ACCEL = 15
const MAXHEALTH = 100
const DEFAULTJUMPFORCE = 330

#Variable Properties
var MAXSPEED = 120
var energy = 100
var energy_max = 100
var energy_regeneration = 8
var motion = Vector2()
var facingRight = true
var applesCount = 0

#set on initial load
onready var health = MAXHEALTH setget _set_health
onready var invulnerablityTimer = $InvulnerabilityTimer
onready var effects_animation = $AnimationPlayer
onready var jumpForce = DEFAULTJUMPFORCE

#Load images
var image_run = load("res://Player/Mask Dude/Run (32x32).png")
var image_idle = load("res://Player/Mask Dude/Idle (32x32).png")
var image_jump = load("res://Player/Mask Dude/Jump (32x32).png")

#health control
func _set_health(value):
	print("Setting Player Health")
	var prevHealth = health
	health = clamp(value, 0, MAXHEALTH)
	if health != prevHealth:
		print("health changed")
		emit_signal("health_updated",self)
		if health == 0:
			print("player Killed")
			kill()
			emit_signal("killed")
			

func damage(amount):
	print("Player damage called")
	if invulnerablityTimer.is_stopped():
		invulnerablityTimer.start()
		_set_health(health - amount)

func kill():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("health_updated",self)

#Called every frame
func _process(delta):
	#Modified energy value
	var new_energy = min(energy + (energy_regeneration + applesCount) * delta, energy_max)
	if new_energy != energy:
		energy = new_energy
		emit_signal("energy_updated",self)
	
#Called every frame to calculate physics
func _physics_process(delta):
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	
	if Input.is_action_pressed("move_right"):
		motion.x += ACCEL
		if is_on_floor():
			facingRight = true
			SetMode("run")
	elif Input.is_action_pressed("move_left"):
		motion.x -= ACCEL
		if is_on_floor():
			facingRight = false
			SetMode("run")
	else:
		motion.x = lerp(motion.x, 0, 0.04)
		if is_on_floor():
			SetMode("idle")
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			if energy >= 20:
				energy = energy - 25
				emit_signal("energy_updated",self)
				print("energy_updated Signal emmited")
				motion.y = -jumpForce
				SetMode("jump")
				$AudioStreamPlayer.play()
		
	if facingRight:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1
	
	motion = move_and_slide(motion,UP)
		
	
	
func SetMode(mode):
	match mode:
		"run":
			$Sprite.texture = image_run
			$Sprite.hframes = 12
			$AnimationPlayer.play("Running")
		"jump":
			$Sprite.texture = image_jump
			$Sprite.hframes = 1
			$AnimationPlayer.play("jump")
		"idle":
			$Sprite.texture = image_idle
			$Sprite.hframes = 11
			$AnimationPlayer.play("Idle")
	


func _on_Cherries_body_entered(body):
	print("Cherry signalled player")
	if body.name == "Player":
		print("Cherry Picked")
		#self.queue_free()
		body.jumpForce = body.jumpForce *1.2
