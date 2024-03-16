extends AnimatedSprite

onready var animatedSprite = self

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: int = 100
var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	print(direction)
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
