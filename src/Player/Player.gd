extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

const DanceEffect = preload("res://World/Friendly/Player1Dance.tscn")

func createDanceEffect():
	var danceEffect = DanceEffect.instance()
	get_parent().add_child(danceEffect)
	danceEffect.global_position = global_position
	if($Sprite):
		$Sprite.queue_free()
	if($Shadow):
		$Shadow.queue_free()
	
enum {
	RUN,
	DODGE,
	ATTACK
}

var state = RUN
var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN
var stats = PlayerStats

const MAX_SPEED = 100
const ACCELERATION = 400
const FRICTION = 400
const ROLL_SPEED = 110

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	stats.connect("noHealth", self, "queue_free")
	animationTree.active = true
	# sets default direction for sword attack to match roll direction
	swordHitbox.knockbackVector = rollVector

#func _physics_process(delta):
#	var collide = move_and_collide(velocity * delta)
#	if collide:
#		print(collide.get_instance_id())
#		velocity = velocity.bounce(collide.normal)
		
func _process(delta):
	#var distance2Hero = enemy.get_global_pos().distance_to(hero.get_global_pos()); if(distance2Hero<100): enemy.throwBulletAt(hero);
	#print(global_position)
	
	match state:
		RUN:
			runState(delta)
	
func runState(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	
	if inputVector != Vector2.ZERO:
		rollVector = inputVector
		swordHitbox.knockbackVector = inputVector
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationTree.set("parameters/Roll/blend_position", inputVector)
		animationState.travel("Run")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
func attackState():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attackStateFinished():
	state = RUN

func dodgeState():
	velocity = move_and_slide(rollVector * ROLL_SPEED)
	animationState.travel("Roll")

func dodgeStateFinished():
	velocity = velocity * 0.9
	state = RUN

func _on_Hurtbox_area_entered(collider):
	hurtbox.startInvincibility(1)
	hurtbox.createHitEffect()
	blinkAnimationPlayer.play("Start")
	stats.setHealth(stats.getHealth() - collider.getDamage())
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	



func _on_Area2D_area_entered(area):
	if(area.name == 'Endgame' && $Sprite):
		createDanceEffect()
