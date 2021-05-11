extends Control

onready var fader = $Fader

func _ready():
	fader.connect("fade_finish", self, "_on_fade_finish")
	fader._fade_in()
	
func _on_Start_pressed():
	fader._fade_out()
	

func _on_fade_finish(anim):
	if anim == "fade_out":
		get_tree().change_scene("res://src/Game/Level.tscn")
