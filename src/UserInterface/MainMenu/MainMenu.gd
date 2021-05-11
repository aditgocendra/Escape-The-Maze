extends Control


onready var fader = get_parent()

func _ready():
	fader.connect("fade_finish", self, "on_fade_finish")
	fader._fade_in()

func _on_Start_pressed():
	fader._fade_out()
	
	
func on_fade_finish(anim):
	if anim == "fade_out":
		get_tree().change_scene("res://src/UserInterface/LevelMenu/LevelMenu.tscn")


func _on_Quit_pressed():
	get_tree().quit()



func _on_Settings_pressed():
	get_tree().change_scene("res://src/UserInterface/Settings/Settings.tscn")


func _on_TestMode_pressed():
	get_tree().change_scene("res://src/Testing/LevelTest.tscn")


func _on_HowToPlay_pressed():
	get_tree().change_scene("res://src/UserInterface/HowToPlay/HowToPlay.tscn")
