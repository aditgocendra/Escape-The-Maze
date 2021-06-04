extends Control

onready var background = $Background
onready var paper_hint = $Background/PaperHint

var counter = 0


func change_tutor():
	if counter == 1:
		background.texture = load("res://assets/UserInterface/HowPlay/Enemy.png")
		paper_hint.texture = load("res://assets/UserInterface/HowPlay/EnemyPaper.png")
	elif counter == 2:
		background.texture = load("res://assets/UserInterface/HowPlay/ClimbTree.png")
		paper_hint.texture = load("res://assets/UserInterface/HowPlay/ClimbPaper.png")
	else:
		background.texture = load("res://assets/UserInterface/HowPlay/Exit.png")
		paper_hint.texture = load("res://assets/UserInterface/HowPlay/ExitPaper.png")
		
func _on_Next_pressed():
	if Autoload.play_sound():
		$ButtonClick.play()
	if counter != 2:
		counter += 1
		$AnimationPlayer.play("change_hint")


func _on_Back_pressed():
	if Autoload.play_sound():
		$ButtonClick.play()
	if counter != 0:
		counter -= 1
		$AnimationPlayer.play("change_hint")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://src/UserInterface/MainMenu/3DSceneMenu.tscn")
