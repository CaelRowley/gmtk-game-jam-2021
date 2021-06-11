extends KinematicBody2D

const BatEffect = preload("res://Effects/BatEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox 
onready var softCollision = $SoftCollision

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
			seekPlayer()			
		WANDER:
			pass
		CHASE:
			if playerDetectionZone.canSeePlayer():
				var player = playerDetectionZone.player
				# var direction = (player.global_position - global_position).normalized()
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			seekPlayer()
				
	sprite.flip_h = velocity.x < 0
	
	if softCollision.isColliding():
		velocity += softCollision.getPushVector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)

func seekPlayer():
	if playerDetectionZone.canSeePlayer():
		state = CHASE
	else:
		state = IDLE

func _on_Hurtbox_area_entered(collider):
	hurtbox.createHitEffect()
	stats.setHealth(stats.getHealth() - collider.getDamage())
	knockback = collider.knockbackVector * 130

func _on_Stats_noHealth():
	var batEffect = BatEffect.instance()
	get_parent().add_child(batEffect)
	batEffect.global_position = global_position
	queue_free()
