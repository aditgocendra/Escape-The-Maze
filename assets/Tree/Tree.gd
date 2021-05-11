extends Spatial



func _on_AreaClimb_body_entered(body):
	if body.name == "Player":
		$Control.show()


func _on_AreaClimb_body_exited(body):
	if body.name == "Player":
		$Control.hide()
