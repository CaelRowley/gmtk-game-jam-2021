extends Camera2D

const SMOOTHING_DURATION: = 0.2

onready var target: Node2D = get_node("../YSort/Player")
onready var currentPosition = position

var destinationPosition

func _process(delta: float):
	destinationPosition = target.position
	currentPosition += Vector2(destinationPosition.x - currentPosition.x, destinationPosition.y - currentPosition.y) / SMOOTHING_DURATION * delta
	
	position = currentPosition.round()
	force_update_scroll()
