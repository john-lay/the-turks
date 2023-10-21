extends AnimatedSprite


# Declare member variables here. Examples:
var speed = 75


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_process(true) # call this script on every frame
	
#func _process(delta): # override function
#	get_node("KinematicBody2D").connect("movement", self, "test")
#	if(Input.is_key_pressed(KEY_UP)):
#		self.set_position(Vector2(self.get_position().x, self.get_position().y - (speed * delta)))
#	if(Input.is_key_pressed(KEY_DOWN)):
#		self.set_position(Vector2(self.get_position().x, self.get_position().y + (speed * delta)))
		
	
#func test(number):
#	print(number)
#connect("animation_finished", self, "anim_fin")

#func anim_fin():
#	if self.animation == "down":
#		animation = "up"
#	else:
#		animation = "down"
