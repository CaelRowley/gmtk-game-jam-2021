extends KinematicBody2D

const BatEffect = preload("res://Effects/BatEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox 
onready var wanderController = $WanderController 
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

func _ready():
	state = getRandomState([IDLE, WANDER])
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			updateState()
		WANDER:
			moveTowardPosition(wanderController.getTargetPosition(), delta)
			if global_position.distance_to(wanderController.targetPosition) <= 1:
				state = getRandomState([IDLE, WANDER])
				wanderController.setWanderTime(rand_range(0.5, 2))
			updateState()
		CHASE:
			if playerDetectionZone.canSeePlayer():
				var player = playerDetectionZone.player
				moveTowardPosition(player.global_position, delta)
			else:
				state = IDLE
			updateState()
			
	velocity = move_and_slide(velocity)
		
func moveTowardPosition(targetPosition, delta):
	var direction = global_position.direction_to(targetPosition)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func updateState():
	if playerDetectionZone.canSeePlayer():
		state = CHASE
	elif wanderController.getTimeLeft() == 0:
		state = getRandomState([IDLE, WANDER])
		wanderController.setWanderTime(rand_range(0.5, 2))

func getRandomState(statesList):
	statesList.shuffle()
	return statesList.pop_front()

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
