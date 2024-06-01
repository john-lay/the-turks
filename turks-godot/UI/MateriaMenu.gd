extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_selection = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.is_visible_in_tree()):
		_get_input()

func _set_selection():
	if current_selection == 1:
		self.animation = "1"
	if current_selection == 2:
		self.animation = "2"
	if current_selection == 3:
		self.animation = "3"
	if current_selection == 4:
		self.animation = "4"


func _get_input():
	if (Input.is_action_just_pressed("ui_down")):
		if current_selection == 4:
			return
		else:
			current_selection +=1
			_set_selection()
	if (Input.is_action_just_pressed("ui_up")):
		if current_selection == 1:
			return
		else:
			current_selection -=1
			_set_selection()
