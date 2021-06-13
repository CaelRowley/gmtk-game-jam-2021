extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
onready var player1Goal = $Area2D

var player1InGoal = false
var player2InGoal = false
var velocity = Vector2.ZERO
const MAX_SPEED = 300
const ACCELERATION = 800

var hasPlayedAudio = false

func _process(delta):
	if(player1InGoal && player2InGoal):
		$AnimatedSprite.animation =  "Attack"
		$KinematicBody2D/Area2D/CollisionShape2D.set_deferred("disabled", false)
	
		velocity = velocity.move_toward(Vector2.RIGHT * MAX_SPEED, ACCELERATION * delta)
		velocity = $KinematicBody2D.move_and_slide(velocity)
		if(!hasPlayedAudio):
			hasPlayedAudio = true
			$AudioStreamPlayer.play()
			$AudioStreamPlayer.stop()
	else:
		$AnimatedSprite.animation =  "Idle"
		$KinematicBody2D/Area2D/CollisionShape2D.set_deferred("disabled", true)

func _on_Area2D_body_entered(body):
	if(body.get_name() == 'Player1'):
		print('player1InGoal = true')
		player1InGoal = true
	if(body.get_name() == 'Player2'):
		print('player2InGoal = true')
		player2InGoal = true


func _on_Area2D_body_exited(body):
	hasPlayedAudio = false
	if(body.get_name() == 'Player1'):
		print('player1InGoal = false')
		player1InGoal = false
	if(body.get_name() == 'Player2'):
		print('player2InGoal = false')
		player2InGoal = false
