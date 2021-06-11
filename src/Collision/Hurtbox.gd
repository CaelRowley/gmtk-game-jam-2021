extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn") 

var invincible = false setget setInvinsible

onready var timer = $Timer

signal invincibilityStarted
signal invincibilityEnded

func setInvinsible(isInvincible):
	invincible = isInvincible
	if invincible == true:
		emit_signal("invincibilityStarted")
	else:
		emit_signal("invincibilityEnded")

func startInvincibility(duration):
	setInvinsible(true)
	timer.start(duration)

func createHitEffect():
	var hitEffect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(hitEffect)
	hitEffect.global_position = global_position - Vector2(0, 12)

func _on_Timer_timeout():
	setInvinsible(false)

func _on_Hurtbox_invincibilityStarted():
	# set_deferred allows you to alter var during physics process
	set_deferred("monitorable", false)
	
func _on_Hurtbox_invincibilityEnded():
	monitorable = true


