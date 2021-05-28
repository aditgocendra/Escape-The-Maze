extends Control





func _on_BtnLevel1_pressed():
	get_tree().change_scene("res://src/Game/Level1.tscn")


func _on_BtnLevel2_pressed():
	get_tree().change_scene("res://src/Game/Level2.tscn")


func _on_BtnLevel3_pressed():
	get_tree().change_scene("res://src/Game/Level3.tscn")


func _on_BackBtn_pressed():
	get_tree().change_scene("res://src/UserInterface/MainMenu/3DSceneMenu.tscn")
