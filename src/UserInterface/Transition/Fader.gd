extends ColorRect


signal fade_finish
signal fade_started


func _fade_in():
	$AnimationPlayer.play("fade_in")


func _fade_out():
	$AnimationPlayer.play("fade_out")

func _trans_main_menu():
	$AnimationPlayer.play("trans_main_menu")

func _fade_out_in():
	$AnimationPlayer.play("fade_out_in")

func _game_over():
	$AnimationPlayer.play("game_over")

func _barrier_transition():
	$AnimationPlayer.play("barrier_trans")
	
func _win():
	$AnimationPlayer.play("win")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finish", anim_name)


func _on_AnimationPlayer_animation_started(anim_name):
	emit_signal("fade_started", anim_name)



