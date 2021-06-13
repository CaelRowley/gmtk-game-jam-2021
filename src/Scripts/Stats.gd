extends Node

export(int) var maxHealth = 1 setget setMaxHealth, getMaxHealth
var health = maxHealth setget setHealth, getHealth

signal noHealth
signal healthChanged(newHealth)
signal maxHealthChanged(newMaxHealth)

func setMaxHealth(newMaxHealth):
	maxHealth = newMaxHealth
	setHealth(min(getHealth(), newMaxHealth))
	emit_signal("maxHealthChanged", newMaxHealth)

func getMaxHealth():
	return health
	
func setHealth(newHealth):
	health = newHealth 
	emit_signal("healthChanged", newHealth)
	if health <= 0:
		emit_signal("noHealth")
		get_tree().change_scene("res://MainMenu.tscn")
		health = maxHealth

func getHealth():
	return health

func _ready():
	setHealth(maxHealth)
