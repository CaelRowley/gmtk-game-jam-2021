extends Control

var playerStats = PlayerStats

var health = 3 setget setHealth, getHealth
var maxHealth  = 3 setget setMaxHealth, getMaxHealth

onready var healthUIFull = $HealthUIFull
onready var healthUIEmpty = $HealthUIEmpty

func setHealth(newHealth):
	health = clamp(newHealth, 0, maxHealth)
	if healthUIFull != null:
		healthUIFull.rect_size.x = health * 15

func getHealth():
	return health
	
func setMaxHealth(newMaxHealth):
	maxHealth = newMaxHealth
	setHealth(min(health, newMaxHealth))
	if healthUIEmpty != null:
		healthUIEmpty.rect_size.x = maxHealth * 15
	
func getMaxHealth():
	return maxHealth
	
func _ready():
	setMaxHealth(playerStats.maxHealth)
	setHealth(playerStats.health)
	playerStats.connect("healthChanged", self, "setHealth")
	playerStats.connect("maxHealthChanged", self, "setMaxHealth")
