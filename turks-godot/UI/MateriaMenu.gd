extends AnimatedSprite


signal close
signal cast_spell

onready var materia_slot1 = $MateriaSlot1
onready var materia_slot2 = $MateriaSlot2
onready var materia_slot3 = $MateriaSlot3
onready var materia_support = $MateriaSupport
onready var materia_dialog = $MateriaDialogLabel
onready var global = get_node("/root/Global")

var current_selection = 1
var _lang: String

# Called when the node enters the scene tree for the first time.
func _ready():
	_lang = global.g_settings["lang"]
	_setLabelText()
	_set_selection()


func _setLabelText():
	var comet_text = global.g_strings["battle"]["materia_comet"][_lang]
	var comet_lv = 9
	materia_slot1.text = comet_text % comet_lv
	
	var curaga_text = global.g_strings["battle"]["materia_curaga"][_lang]
	var curaga_lv = 9
	materia_slot2.text = curaga_text % curaga_lv
	
	var blizzara_text = global.g_strings["battle"]["materia_blizzara"][_lang]
	var blizzara_lv = 8
	materia_slot3.text = blizzara_text % blizzara_lv

	materia_support.text = global.g_strings["battle"]["materia_support"][_lang]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.is_visible_in_tree()):
		_get_input()

func _set_selection():
	var dialog_text = global.g_strings["battle"]["materia_spend"][_lang]
	var materia_mp = 0
	if current_selection == 1:
		self.animation = "1"
		materia_mp = 6
		materia_dialog.text = dialog_text % materia_mp
	if current_selection == 2:
		self.animation = "2"
		materia_mp = 90
		materia_dialog.text = dialog_text % materia_mp
	if current_selection == 3:
		self.animation = "3"
		materia_mp = 35
		materia_dialog.text = dialog_text % materia_mp
	if current_selection == 4:
		self.animation = "4"
		materia_dialog.text = "???"


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
	if (Input.is_action_just_pressed("ui_cancel")):
		emit_signal("close")
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("cast_spell", current_selection)

