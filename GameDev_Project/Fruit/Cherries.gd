extends Area2D

signal cherryEaten

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Cherries_body_entered(body):
	if body.name == "Player":
		print("Cherry freed")
		queue_free()
