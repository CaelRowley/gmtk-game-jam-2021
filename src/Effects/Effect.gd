extends AnimatedSprite

func _ready():
	# warning-ignore:return_value_discarded
	connect("animation_finished", self, "onAnimationFinished")
	frame = 0
	play("Animate")

func onAnimationFinished():
	queue_free()
