extends Control

onready var fader = $Fader

var next_scene : String = ""



func _on_BtnLevel1_pressed():
	next_scene = "res://src/Game/Level1.tscn"
	button_on_click()


func _on_BtnLevel2_pressed():
	next_scene = "res://src/Game/Level2.tscn"
	button_on_click()


func _on_BtnLevel3_pressed():
	next_scene = "res://src/Game/Level3.tscn"
	button_on_click()


func _on_BackBtn_pressed():
	next_scene = "res://src/UserInterface/MainMenu/3DSceneMenu.tscn"
	button_on_click()


func on_fade_finish(anim):
	if anim == "fade_out":
		get_tree().change_scene(next_scene)


func button_on_click():
	if Autoload.play_sound():
		$ButtonClick.play()
	fader._fade_out()
