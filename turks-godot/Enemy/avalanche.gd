extends KinematicBody2D

export(PackedScene) var ENEMY_PROJECTILE: PackedScene = preload("res://Enemy/EnemyProjectile.tscn")

enum STATE {
	IDLE
	NEW_DIRECTION
	MOVE
	ATTACK
}

const SPEED:int = 50 # speed in pixels/sec
var state = STATE.MOVE
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.LEFT

onready var stateTimer = $StateTimer
onready var damageLabel = $DamageLabel
onready var damageLabelTimer = $DamageLabelTimer
onready var animatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	damageLabel.visible = false
	randomize()


func fire_projectile():
	if ENEMY_PROJECTILE:
		var projectile = ENEMY_PROJECTILE.instance()
		projectile.position = self.position
		projectile.set("direction", direction)
		get_tree().current_scene.add_child(projectile)

func enemy_hit():
	damageLabel.text = "9999"
	damageLabel.visible = true
	damageLabelTimer.start(0.5)
#	print("enemy has been hit!")

func _process(delta):
	match state:
		STATE.IDLE:
			pass
		STATE.NEW_DIRECTION:
			direction = choose([Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT])
			state = choose([STATE.IDLE, STATE.MOVE])
		STATE.MOVE:
			move(delta)
		STATE.ATTACK:
			attack()

func set_move_animation():
	velocity = Vector2.ZERO	
	if (direction == Vector2.UP):
		velocity.y -= 1
		animatedSprite.animation = "move-up"
	if (direction == Vector2.DOWN):
		velocity.y += 1
		animatedSprite.animation = "move-down"
	if (direction == Vector2.LEFT):
		velocity.x -= 1
		animatedSprite.animation = "move-left"
	if (direction == Vector2.RIGHT):
		velocity.x += 1
		animatedSprite.animation = "move-right"

func set_attack_animation():
	if (direction == Vector2.UP):
		animatedSprite.animation = "attack-up"
	if (direction == Vector2.DOWN):
		animatedSprite.animation = "attack-down"
	if (direction == Vector2.LEFT):
		animatedSprite.animation = "attack-left"
	if (direction == Vector2.RIGHT):
		animatedSprite.animation = "attack-right"

func move(delta):
	set_move_animation()
	velocity = velocity.normalized() * SPEED
	velocity = move_and_slide(velocity)

func attack():
	set_attack_animation()
	fire_projectile()
	
func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	damageLabel.visible = false

func _on_StateTimer_timeout():
	stateTimer.wait_time = choose([0.5, 1, 1.5])
	state = choose([STATE.IDLE, STATE.NEW_DIRECTION, STATE.MOVE, STATE.ATTACK])
