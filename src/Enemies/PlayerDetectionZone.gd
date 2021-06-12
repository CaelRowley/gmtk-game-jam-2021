extends Area2D

var player = null

func canSeePlayer():
	return player != null
	
func _on_PlayerDetectionZone_body_entered(body):
	player = body

func _on_PlayerDetectionZone_body_exited(_body):
	player = null


func _on_PlayerDetectionZone_area_entered(area):
	player = area

func _on_PlayerDetectionZone_area_exited(area):
	player = null
