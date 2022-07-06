extends Node

signal ApplesCollected

onready var health_bar = $HealthBar
onready var energy_bar = $EnergyBar
onready var applesBar = [$ApplesBar/Apple1, $ApplesBar/Apple2, $ApplesBar/Apple3, $ApplesBar/Apple4, $ApplesBar/Apple5, $ApplesBar/Apple6]


func _ready():
	pass
	

func ConnectSignals():
	self.connect("energy_updated", self, "update_energy")
	self.connect("health_updated", self, "_on_health_updated")
	print("Connected Energy Updating")



func _on_health_updated(Player):
	print("updating health Bar")
	health_bar.value = Player.health
	
func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
	
func update_energy(Player):
	energy_bar.value = Player.energy
	update_appleBar(Player.applesCount)

func update_appleBar(number):
	var i = 0
	for a in applesBar:
		i += 1
		if i > number:
			a.visible = false
		else:
			a.visible = true
	if number > 5:
		emit_signal("ApplesCollected")
	#$ApplesBar/Apple3.visible = false
