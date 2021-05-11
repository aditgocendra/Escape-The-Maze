extends Spatial



func _on_AreaExit_body_entered(body):
	if body.name == "Player":
		body.win()
