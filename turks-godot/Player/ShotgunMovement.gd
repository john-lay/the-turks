extends KinematicBody2D

var speed: int = 175  # speed in pixels/sec
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

export(PackedScene) var PROJECTILE: PackedScene = preload("res://Battle/ProjectileSprite.tscn")

onready var animatedSprite = $AnimatedSprite

# the below line is equivalent to
#onready var projectile = $ProjectileSprite
# the below 3 lines
#var projectile
#func _ready():
#	projectile = get_node("ProjectileSprite")

func set_idle_direction():
	if direction == Vector2.RIGHT:
		animatedSprite.animation = "idle-right"
	if direction == Vector2.LEFT:
		animatedSprite.animation = "idle-left"
	if direction == Vector2.DOWN:
		animatedSprite.animation = "idle-down"
	if direction == Vector2.UP:
		animatedSprite.animation = "idle-up"

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
		
func fire_projectile():
	if direction == Vector2.ZERO:
		pass
	else:
		if PROJECTILE:
			var projectile = PROJECTILE.instance()
			projectile.position = get_shot_start_position()
			projectile.set("direction", direction)
			get_tree().current_scene.add_child(projectile)

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
		fire_projectile()
	else:
		set_idle_direction()
	

func _physics_process(_delta):
	get_input()
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
