extends KinematicBody2D

export(PackedScene) var ENEMY_PROJECTILE: PackedScene = preload("res://Enemy/EnemyProjectile.tscn")

# Declare member variables here. Examples:
var direction: Vector2 = Vector2.ZERO
onready var damageLabel = $DamageLabel
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	damageLabel.visible = false
	fire_projectile()


func fire_projectile():
	if ENEMY_PROJECTILE:
		var projectile = ENEMY_PROJECTILE.instance()
		projectile.position = self.position
		projectile.set("direction", Vector2.LEFT)
		get_tree().current_scene.add_child(projectile)

func enemy_hit():
	damageLabel.text = "9999"
	damageLabel.visible = true
	timer.start(0.5)
#	print("enemy has been hit!")

func _physics_process(delta):
	fire_projectile()
	
func _on_Timer_timeout():
	damageLabel.visible = false
