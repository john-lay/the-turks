extends KinematicBody2D

var speed: int = 175  # speed in pixels/sec
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
enum STATE {
	MOVE,
	ATTACK
}

var state = STATE.MOVE

export(PackedScene) var PROJECTILE: PackedScene = preload("res://Battle/ProjectileSprite.tscn")

onready var animatedSprite = $AnimatedSprite
var isAttacking: bool = false

# the below line is equivalent to
#onready var projectile = $ProjectileSprite
# the below 3 lines
#var projectile
#func _ready():
#	projectile = get_node("ProjectileSprite")

#func _ready():
#	animatedSprite.connect("animation_finished",self, "animation_finished")

func set_idle_direction():
	if direction == Vector2.RIGHT:
		animatedSprite.animation = "idle-right"
	if direction == Vector2.LEFT:
		animatedSprite.animation = "idle-left"
	if direction == Vector2.DOWN:
		animatedSprite.animation = "idle-down"
	if direction == Vector2.UP:
		animatedSprite.animation = "idle-up"

func set_attack_direction():
	if direction == Vector2.RIGHT:
		animatedSprite.animation = "attack-right"
	if direction == Vector2.LEFT:
		animatedSprite.animation = "attack-left"
	if direction == Vector2.DOWN:
		animatedSprite.animation = "attack-down"
	if direction == Vector2.UP:
		animatedSprite.animation = "attack-up"
	isAttacking = true

func get_shot_start_position() -> Vector2:
	var position: Vector2
	if direction == Vector2.RIGHT:
		position.x = self.position.x + 32 + 32
		position.y = self.position.y + 32
	if direction == Vector2.LEFT:
		position.x = self.position.x
		position.y = self.position.y + 32
	if direction == Vector2.DOWN:
		position.x = self.position.x + 32
		position.y = self.position.y + 32 + 32
	if direction == Vector2.UP:
		position.x = self.position.x + 32
		position.y = self.position.y
	return position

func get_left_shot_start_position() -> Vector2:
	var position: Vector2 = get_shot_start_position()
	var distance_from_player: int = 16
	var shot_spacing: int = 24
	if direction == Vector2.RIGHT:
		position.x += distance_from_player
		position.y -= shot_spacing
	if direction == Vector2.LEFT:
		position.x -= distance_from_player
		position.y += shot_spacing
	if direction == Vector2.DOWN:
		position.x += shot_spacing
		position.y += distance_from_player
	if direction == Vector2.UP:
		position.x -= shot_spacing
		position.y -= distance_from_player
	return position

func get_right_shot_start_position() -> Vector2:
	var position: Vector2 = get_shot_start_position()
	var distance_from_player: int = 16
	var shot_spacing: int = 24
	if direction == Vector2.RIGHT:
		position.x += distance_from_player
		position.y += shot_spacing
	if direction == Vector2.LEFT:
		position.x -= distance_from_player
		position.y -= shot_spacing
	if direction == Vector2.DOWN:
		position.x -= shot_spacing
		position.y += distance_from_player
	if direction == Vector2.UP:
		position.x += shot_spacing
		position.y -= distance_from_player
	return position

func fire_projectile():
	if PROJECTILE:
		var projectile = PROJECTILE.instance()
		projectile.position = get_shot_start_position()
		projectile.set("direction", direction)
		get_tree().current_scene.add_child(projectile)
		var projectile_left = PROJECTILE.instance()
		projectile_left.position = get_left_shot_start_position()
		projectile_left.set("direction", direction)
		get_tree().current_scene.add_child(projectile_left)
		var projectile_right = PROJECTILE.instance()
		projectile_right.position = get_right_shot_start_position()
		projectile_right.set("direction", direction)
		get_tree().current_scene.add_child(projectile_right)
		state = STATE.MOVE

func should_launch_projectile():
	if isAttacking:
		var last_attack_frame: int = 3
		if (direction == Vector2.UP || direction == Vector2.DOWN):
			last_attack_frame = 4
		if (animatedSprite.get_frame() == last_attack_frame): 
			isAttacking = false
			fire_projectile()

#func animation_finished():
#	var completedAnimation = animatedSprite.get_animation()
#	print("completedAnimation = ", completedAnimation)
#	if completedAnimation == "attack-up" \
#		|| completedAnimation == "attack-down" \
#		|| completedAnimation == "attack-left" \
#		|| completedAnimation == "attack-right":
#		fire_projectile()
#		state = STATE.MOVE

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		animatedSprite.animation = "move-right"
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		animatedSprite.animation = "move-left"
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		animatedSprite.animation = "move-down"
		direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		animatedSprite.animation = "move-up"
		direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_accept"):
		if direction == Vector2.ZERO:
			pass
		else:
			state = STATE.ATTACK
			set_attack_direction()
	else:
		if state == STATE.MOVE:
			set_idle_direction()

func _physics_process(_delta):
	get_input()
	should_launch_projectile()
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
	
func player_hit():
	print("shotgun hit by enemy projectile")
