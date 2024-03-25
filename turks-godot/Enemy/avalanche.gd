extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var damageLabel = $DamageLabel
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	damageLabel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func enemy_hit():
	damageLabel.text = "9999"
	damageLabel.visible = true
	timer.start(0.5)
#	print("enemy has been hit!")


func _on_Timer_timeout():
	damageLabel.visible = false
