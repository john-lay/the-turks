extends AnimatedSprite


signal close

onready var materia_slot1 = $MateriaSlot1
onready var materia_slot2 = $MateriaSlot2
onready var materia_slot3 = $MateriaSlot3
onready var materia_support = $MateriaSupport
onready var global = get_node("/root/Global")

var current_selection = 1
var _lang: String

# Called when the node enters the scene tree for the first time.
func _ready():
	_lang = global.g_settings["lang"]
	_setLabelText()


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
	if (Input.is_action_just_pressed("ui_cancel")):
		emit_signal("close")
