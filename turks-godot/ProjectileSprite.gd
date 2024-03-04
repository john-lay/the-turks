extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed: int = 100
var fired: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var direction = Vector2.RIGHT
	if (fired):
		global_position += speed * direction * delta
