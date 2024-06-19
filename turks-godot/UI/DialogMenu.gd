extends Node2D

signal menu_complete

onready var options_label = $OptionsLabel
onready var option1 = $OptionOne
onready var option2 = $OptionTwo
onready var navigate_audio = $NavigateAudio

var current_selection: int = 0
var manage_input: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	option2.visible = false


func _set_selection():
	if current_selection == 0:
		option2.visible = false
		option1.visible = true
	elif current_selection == 1:
		option1.visible = false
		option2.visible = true


func _get_input():
	if (Input.is_action_just_pressed("ui_down")):
		if current_selection == 1:
			return
		else:
			current_selection +=1
			navigate_audio.play()
			_set_selection()
	if (Input.is_action_just_pressed("ui_up")):
		if current_selection == 0:
			return
		else:
			current_selection -=1
			navigate_audio.play()
			_set_selection()
	if (Input.is_action_just_pressed("ui_accept")):
		emit_signal("menu_complete", current_selection)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (self.is_visible_in_tree() && manage_input):
		_get_input()


func should_manage_input():
	# add a slight delay to prevent dialog box input being read here
	yield(get_tree().create_timer(0.5), "timeout")
	manage_input = true
