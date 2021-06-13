extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	print('HENLO')
	print(area)
	$Chain1.queue_free()
	$Chain2.queue_free()
	$Chain3.queue_free()
	$Chain4.queue_free()
	$Chain5.queue_free()
	$Chain6.queue_free()
	$Chain7.queue_free()
	$Chain8.queue_free()
	$ChainLast.queue_free()


func _on_Area2D_area_exited(area):
	print('HENLO')
	print(area)
	$Chain1.queue_free()
	$Chain2.queue_free()
	$Chain3.queue_free()
	$Chain4.queue_free()
	$Chain5.queue_free()
	$Chain6.queue_free()
	$Chain7.queue_free()
	$Chain8.queue_free()
	$ChainLast.queue_free()
