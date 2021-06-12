extends KinematicBody2D

const BatEffect = preload("res://Effects/BatEffect.tscn")

enum {
	RUN,
}

var state = RUN
var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN
var knockback = Vector2.ZERO

const MAX_SPEED = 100
const ACCELERATION = 400
const FRICTION = 400
const ROLL_SPEED = 110


onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox 
onready var wanderController = $WanderController 
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _process(delta):
	match state:
		RUN:
			runState(delta)
		
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
		
func runState(delta):
	var inputVector = Vector2.ZERO
	if playerDetectionZone.canSeePlayer():
		inputVector.x = Input.get_action_strength("player2_right") - Input.get_action_strength("player2_left")
		inputVector.y = Input.get_action_strength("player2_down") - Input.get_action_strength("player2_up")
		inputVector = inputVector.normalized()
	
	if inputVector != Vector2.ZERO:
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	sprite.flip_h = velocity.x < 0

func _on_Hurtbox_area_entered(collider):
	hurtbox.createHitEffect()
	blinkAnimationPlayer.play("Start")
	stats.setHealth(stats.getHealth() - collider.getDamage())
	knockback = collider.knockbackVector * 130
	hurtbox.startInvincibility(0.1)

func _on_Stats_noHealth():
	var batEffect = BatEffect.instance()
	get_parent().add_child(batEffect)
	batEffect.global_position = global_position
	queue_free()
