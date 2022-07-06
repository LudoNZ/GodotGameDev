extends KinematicBody2D

const CHERRY = preload("res://Fruit/Cherries.tscn")

const UP = Vector2(0,-1)
const GRAVITY = 12
const MAXFALLSPEED = 250
const MAXSPEED = 120
const JUMPFORCE = 200

export var motion = Vector2()
onready var ACCEL = -1
var facingRight = true



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	pass
	
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)

#	if Input.is_action_pressed("move_right"):
	motion.x += ACCEL
	if is_on_floor():
		facingRight = true
		#$AnimatedSprite.play("run")
#	elif Input.is_action_pressed("move_left"):
#		motion.x -= ACCEL
#		if is_on_floor():
#			$AnimatedSprite.play("run")
#			facingRight = false
#	else:
#		motion.x = lerp(motion.x, 0, 0.04)
#		if is_on_floor():
#			$AnimatedSprite.play("idle")
#
#	if is_on_floor():
#		if Input.is_action_just_pressed("jump"):
#			motion.y = -JUMPFORCE
#			#SetMode("jump")
#
#	if facingRight:
#		$AnimatedSprite.scale.x = 1
#	else:
#		$AnimatedSprite.scale.x = -1
#
	motion = move_and_slide(motion,UP)
		
	
func _on_top_checker_body_entered(body):
	if body.name == "Player":
		
		print("enemy Squashed")
		$AnimatedSprite.play("hit")
		$AudioStreamPlayer.play()
		add_cherry()
		
func add_cherry():
	var myCherry = CHERRY.instance()
	$Position2D.add_child(myCherry)
	print("Cherry Pooped")


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("idle")


func _on_Side_bumper_body_entered(body):
	print("bumped")
	motion.x = 0
	ACCEL = - ACCEL
	motion = move_and_slide(motion,UP)
	
	if body.name == "Player":
		print("Player bumped")
		body.jumpForce = body.DEFAULTJUMPFORCE
		body.damage(30)
		print("health remaining: " + str(body.health))
