extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer
var down_ani_start_frame = 16
var down_ani_frames = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	self.frame = down_ani_start_frame
	timer = Timer.new()
	timer.connect("timeout", self, "tick")
	add_child(timer)
	timer.wait_time = 0.2
	timer.start()
	
	
func tick():
	if self.frame < down_ani_start_frame + down_ani_frames -1:
		self.frame = self.frame + 1
	else:
		self.frame = down_ani_start_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
