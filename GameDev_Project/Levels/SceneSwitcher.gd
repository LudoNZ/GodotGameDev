extends Node

var next_level = null
var next_level_name: String

onready var current_level = $Level1
onready var anim = $AnimationPlayer
onready var energyBar = $CanvasLayer/PlayerStats/EnergyBar
onready var player_stats = $CanvasLayer/PlayerStats
onready var player = $Level1/Player

func _ready():
	ConnectLevel()
	player.get_node("Camera2D").current = true

#Connect Signals
func ConnectLevel():
	current_level.connect("level_changed", self, "handle_level_changed")
	print("Connected level changed Signal to Scene_Switcher")
	
	player.connect("energy_updated", player_stats, "update_energy")
	player.connect("health_updated", player_stats, "_on_health_updated")
	
	player_stats.connect("ApplesCollected", current_level,"find_node")


# Level Change
func handle_level_changed(current_level_name: String):
	print("handle_level_change called Successfully")
	
	match current_level_name:
		"Level1":
			next_level_name = "Level2"
		"Level2":
			next_level_name = "Level3"
		"Level3":
			next_level_name = "Level1"
			player.JUMPFORCE = 300
		_:
			return
	
	anim.play("fadeIn")			
	
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fadeIn":
			next_level = load("res://Levels/" + next_level_name + ".tscn").instance()
			add_child(next_level)
			next_level.connect("level_changed", self, "handle_level_changed")
			
			#Carry data over to next Scene
			levelChangeDataTransfer(current_level, next_level)
			
			current_level.queue_free()
			current_level = next_level
			next_level = null
			anim.play("fadeOut")
			ConnectLevel()

func levelChangeDataTransfer(oldScene, newScene):
	
	newScene.get_node("Player").jumpForce = oldScene.get_node("Player").jumpForce  #$Player.JUMPFORCE = oldScene.$Player.JUMPFORCE
	player = newScene.get_node("Player")
	player.applesCount = 0
