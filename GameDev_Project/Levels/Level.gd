extends Node

signal level_changed(level_name)

export (String) var level_name = "Level"


func _on_ChangeLevel_body_entered(body):
	if body == $Player:
		print("Player detected")
		call_deferred("emit_signal","level_changed", level_name)


func _on_Finish_body_entered(body):
	if body == $Player:
		print("Player detected")
		call_deferred("emit_signal","level_changed", level_name)
		if level_name == "LevelMenu":
			get_tree().change_scene("res://Levels/SceneSwitcher.tscn")
			
func Activate_Finish():
	pass
