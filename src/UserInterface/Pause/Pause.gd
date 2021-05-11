extends Control



func _on_Next_pressed():
	get_tree().paused = false
	self.queue_free()


func _on_Kembali_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://src/UserInterface/MainMenu/3DSceneMenu.tscn")
