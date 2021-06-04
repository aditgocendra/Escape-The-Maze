extends Control


onready var fader = get_parent()
onready var sound_click = $ButtonClick

var next_scene : String = ""


func _ready():
	fader.connect("fade_finish", self, "on_fade_finish")
	fader._fade_in()

func _on_Start_pressed():
	if Autoload.play_sound():
		$ButtonClick.play()
	next_scene = "res://src/UserInterface/LevelMenu/LevelMenu.tscn"
	fader._fade_out()
	
	
func on_fade_finish(anim):
	if anim == "fade_out":
		if next_scene == "":
			get_tree().quit()
# warning-ignore:return_value_discarded
		else: get_tree().change_scene(next_scene)


func _on_Quit_pressed():
	next_scene = ""
	button_on_click()

func _on_Settings_pressed():
	next_scene = "res://src/UserInterface/Settings/Settings.tscn"
	button_on_click()

func _on_TestMode_pressed():
	next_scene = "res://src/Testing/LevelTest.tscn"
	button_on_click()

func _on_HowToPlay_pressed():
	next_scene = "res://src/UserInterface/HowToPlay/HowToPlay.tscn"
	button_on_click()

func button_on_click():
	if Autoload.play_sound():
		$ButtonClick.play()
	fader._fade_out()
