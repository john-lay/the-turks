extends Node2D

signal close
signal select

onready var menu_ui = $AnimatedSprite
onready var select_audio = $SelectAudio
onready var navigate_audio = $NavigateAudio
onready var unavailable_audio = $UnavailableAudio
onready var option1 = $Option1Text
onready var option2 = $Option2Text
onready var option3 = $Option3Text
onready var option4 = $Option4Text
onready var option5 = $Option5Text
onready var option6 = $Option6Text
onready var global = get_node("/root/Global")

var current_selection = 1
var _lang: String
var manage_input: bool = false

func _ready():
	_lang = global.g_settings["lang"]
	_setOptionText()
	_set_selection()


func _setOptionText():
	option1.text = global.g_strings["overworld_menu"]["status"][_lang]
	option2.text = global.g_strings["overworld_menu"]["item"][_lang]
	option3.text = global.g_strings["overworld_menu"]["materia_equipment"][_lang]
	option4.text = global.g_strings["overworld_menu"]["member_list"][_lang]
	option5.text = global.g_strings["overworld_menu"]["options"][_lang]
	option6.text = global.g_strings["overworld_menu"]["return_to_hq"][_lang]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.is_visible_in_tree() && manage_input):
		_get_input()


func _set_selection():
	if current_selection == 1:
		menu_ui.animation = "1"
	if current_selection == 2:
		menu_ui.animation = "2"
	if current_selection == 3:
		menu_ui.animation = "3"
	if current_selection == 4:
		menu_ui.animation = "4"
	if current_selection == 5:
		menu_ui.animation = "5"
	if current_selection == 6:
		menu_ui.animation = "6"


func _get_input():
	if (Input.is_action_just_pressed("ui_down")):
		if current_selection == 6:
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
	if (Input.is_action_just_pressed("ui_cancel")):
#		print("overworld menu emitting close signal")
		manage_input = false
		emit_signal("close")
		navigate_audio.play()
	if Input.is_action_just_pressed("ui_accept"):
#		print("overworld menu emitting select signal")
#		if current_selection == 1:
#			emit_signal("select", current_selection)
#			select_audio.play()
#		else:
			unavailable_audio.play()


func should_manage_input():
	manage_input = true
