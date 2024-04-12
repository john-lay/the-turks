extends KinematicBody2D

export(PackedScene) var ENEMY_PROJECTILE: PackedScene = preload("res://Enemy/EnemyProjectile.tscn")

signal request_player_position()

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
var canAttack: bool = true
var collidedWithBackground: bool = false
var playerPosition: Vector2

onready var stateTimer = $StateTimer
onready var damageLabel = $DamageLabel
onready var damageLabelTimer = $DamageLabelTimer
onready var bulletTimer = $BulletTimer
onready var animatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	damageLabel.visible = false
	randomize()

func get_bullet_start_position() -> Vector2:
	var position: Vector2
	if direction == Vector2.RIGHT:
		position.x = self.position.x + 24
		position.y = self.position.y - 8
	if direction == Vector2.LEFT:
		position.x = self.position.x - 24
		position.y = self.position.y - 8
	if direction == Vector2.DOWN:
		position.x = self.position.x
		position.y = self.position.y
	if direction == Vector2.UP:
		position.x = self.position.x
		position.y = self.position.y - 24
	return position

func fire_projectile():
	if ENEMY_PROJECTILE:
		var projectile = ENEMY_PROJECTILE.instance()
		projectile.position = self.position
		projectile.position = get_bullet_start_position()
		projectile.set("direction", direction)
		get_tree().current_scene.add_child(projectile)

func is_playing_attack_animation():
	var completedAnimation = animatedSprite.get_animation()
#	print("completedAnimation = ", completedAnimation)
	return completedAnimation == "attack-up" \
		|| completedAnimation == "attack-down" \
		|| completedAnimation == "attack-left" \
		|| completedAnimation == "attack-right"

func should_launch_projectile():
	if (canAttack && is_playing_attack_animation()):
		var attack_frame: int = 1 # frame where the firearm recoils
		if (animatedSprite.get_frame() == attack_frame):
			canAttack = false
			bulletTimer.start(0.5)
			fire_projectile()
			
func enemy_hit():
	damageLabel.text = "9999"
	damageLabel.visible = true
	damageLabelTimer.start(0.5)
#	print("enemy has been hit!")

func _process(delta):
	get_player_position()
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
	if (get_last_slide_collision() != null):
		if (get_last_slide_collision().collider.is_in_group("bg")):
#			print("enemy touching bg, needs to change direction")
			collidedWithBackground = true

func get_attack_direction() -> Vector2:
	var dx: int
	var dy: int
	var dirX: Vector2
	var dirY: Vector2
	if (playerPosition.x > self.position.x):
		dx = playerPosition.x - self.position.x
		dirX = Vector2.RIGHT
#		print("player to enemies right")
	elif (playerPosition.x < self.position.x):
		dx = self.position.x - playerPosition.x
		dirX = Vector2.LEFT
#		print("player to enemies left")
	if (playerPosition.y > self.position.y):
		dy = playerPosition.y - self.position.y
		dirY = Vector2.DOWN
#		print("player below enemy")
	elif (playerPosition.y < self.position.y):
		dy = self.position.y - playerPosition.y
		dirY = Vector2.UP
#		print("player above enemy")
	if (dx > dy):
		return dirX
	else:
		return dirY
	
func attack():
	direction = get_attack_direction()
	set_attack_animation()
	should_launch_projectile()
#	get_player_position()
	
func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	damageLabel.visible = false

func _on_StateTimer_timeout():
	stateTimer.wait_time = choose([0.5, 1, 1.5])
	print("state timer expired, new timer = ", stateTimer.wait_time)
	if (collidedWithBackground):
		# move enemy in opposite direction
		collidedWithBackground = false
#		print("collided with bg, direction was: ", direction)
		if (direction == Vector2.LEFT): direction = Vector2.RIGHT
		elif (direction == Vector2.RIGHT): direction = Vector2.LEFT
		elif (direction == Vector2.UP): direction = Vector2.DOWN
		elif (direction == Vector2.DOWN): direction = Vector2.UP
		state = STATE.MOVE
	else:
		state = choose([STATE.IDLE, STATE.NEW_DIRECTION, STATE.MOVE, STATE.ATTACK])

func _on_BulletTimer_timeout():
	canAttack = true

func get_player_position():
	emit_signal("request_player_position")

func player_position_received(player_position:Vector2):
#	print("player_position received", player_position)
	playerPosition = player_position
