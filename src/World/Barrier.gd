extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
onready var player1Goal = $Area2D

var player1InGoal = false
var player2InGoal = false

func createGrassEffect():
	print(global_position)
	for n in 4:
		var grassEffect = GrassEffect.instance()
		get_parent().add_child(grassEffect)
		grassEffect.global_position = Vector2(global_position.x - (n * 12), global_position.y)
		queue_free()
	for n in 4:
		var grassEffect = GrassEffect.instance()
		get_parent().add_child(grassEffect)
		grassEffect.global_position = Vector2(global_position.x + (n * 12), global_position.y)
		queue_free()


func _on_Hurtbox_area_entered(_area):
	createGrassEffect()
	
func _process(delta):
	if(player1InGoal && player2InGoal):
		createGrassEffect()


func _on_Area2D_body_entered(body):
	print(body.get_name(), ' entered')
	if(body.get_name() == 'Player1'):
		print('player1InGoal = true')
		player1InGoal = true
	if(body.get_name() == 'Player2'):
		print('player2InGoal = true')
		player2InGoal = true

func _on_Area2D_body_exited(body):
	print(body.get_name(), ' left')
	if(body.get_name() == 'Player1'):
		print('player1InGoal = false')
		player1InGoal = false
	if(body.get_name() == 'Player2'):
		print('player2InGoal = false')
		player2InGoal = false
