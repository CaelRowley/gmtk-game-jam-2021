extends AudioStreamPlayer


func _on_PlayerHurtSound_finished():
	# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")
