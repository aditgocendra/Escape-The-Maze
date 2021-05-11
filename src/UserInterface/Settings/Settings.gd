extends Control

onready var slider_sensi = $Background/Paper/VBoxContainer/ContainerSensi/HSlider
onready var check_sound = $Background/Paper/VBoxContainer/ContainerSound/CheckBox

var data

func _ready():
	data = Database.loadData()
	set_settings()
	


func set_settings():
	var data_settings = data["game"]["settings"]
	#sounds
	if data_settings["sound"] == true:
		check_sound.text = "On"
		check_sound.pressed = true
	else:
		check_sound.text = "Off"
		check_sound.pressed = false
	
	slider_sensi.value = data_settings["sensitivity"]



func _on_CheckBox_pressed():
	if check_sound.pressed == true:
		check_sound.text = "On"
	else:check_sound.text = "Off"
		


func _on_Apply_pressed():
	data["game"]["settings"]["sensitivity"] = slider_sensi.value
	data["game"]["settings"]["sound"] = check_sound.pressed
	
	Database.save_data(data)
	get_tree().change_scene("res://src/UserInterface/MainMenu/3DSceneMenu.tscn")
	
	
func _on_Back_pressed():
	get_tree().change_scene("res://src/UserInterface/MainMenu/3DSceneMenu.tscn")
