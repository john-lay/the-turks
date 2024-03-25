extends AnimatedSprite

onready var animatedSprite = self

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: int = 200
var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	if direction == Vector2.RIGHT:
		animatedSprite.animation = "right"
	if direction == Vector2.LEFT:
		animatedSprite.animation = "left"
	if direction == Vector2.DOWN:
		animatedSprite.animation = "down"
	if direction == Vector2.UP:
		animatedSprite.animation = "up"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
#	set_sprite_direction()
#	if (fired):
	global_position += speed * direction * delta


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy_group"):
#		print("projectile collided with ", body.name)
		self.queue_free()
