extends AnimatedSprite

var speed: int = 200
var direction: Vector2 = Vector2.ZERO

func _ready():
	if direction == Vector2.RIGHT:
		self.animation = "right"
	if direction == Vector2.LEFT:
		self.animation = "left"
	if direction == Vector2.DOWN:
		self.animation = "down"
	if direction == Vector2.UP:
		self.animation = "up"

func _physics_process(delta):
	global_position += speed * direction * delta

func _on_Area2D_body_entered(body):
	if body.is_in_group("player_group"):
#		print("projectile collided with ", body.name)
		self.queue_free()
		if body.has_method("player_hit"):
			body.player_hit()
