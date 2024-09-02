extends Node2D

signal select

onready var menu_ui = $AnimatedSprite
onready var select_audio = $SelectAudio
onready var navigate_audio = $NavigateAudio
onready var name_entry = $NameEntry
onready var global = get_node("/root/Global")

var current_selection = 1
var manage_input: bool = false

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.is_visible_in_tree() && manage_input):
		_get_input()


func _set_selection():
	if current_selection == 1:
		menu_ui.animation = "1"
	if current_selection == 2:
		menu_ui.animation = "2"


func _get_input():
	if (Input.is_action_just_pressed("ui_down")):
		if current_selection == 2:
			return
		else:
			current_selection +=1
			navigate_audio.play()
			_set_selection()
	if (Input.is_action_just_pressed("ui_up")):
		if current_selection == 1:
			return
		else:
			current_selection -=1
			navigate_audio.play()
			_set_selection()
	if Input.is_action_just_pressed("ui_accept"):
		manage_input = false
		_set_player_name()
		emit_signal("select", current_selection)
		select_audio.play()


func _get_default_player_name():
	if current_selection == 1:
		return "Ellen"
	if current_selection == 2:
		return "エレン"


func _set_player_name():
	if name_entry.text == "":
		global.g_settings["player_name"] = _get_default_player_name()
	else:
		global.g_settings["player_name"] = name_entry.text


func should_manage_input():
	manage_input = true
