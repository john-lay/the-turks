extends AnimatedSprite


signal close
signal cast_spell

onready var materia_slot1 = $MateriaSlot1
onready var materia_slot2 = $MateriaSlot2
onready var materia_slot3 = $MateriaSlot3
onready var materia_support = $MateriaSupport
onready var materia_dialog = $MateriaDialogLabel
onready var select_audio = $SelectAudio
onready var navigate_audio = $NavigateAudio
onready var unavailable_audio = $UnavailableAudio
onready var global = get_node("/root/Global")

var current_selection = 1
var _lang: String
var manage_input: bool = false
var spell_cost: int = 0
var player_mp: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_lang = global.g_settings["lang"]
	_setLabelText()
	_set_selection()


func _setLabelText():
	var thunder_text = global.g_strings["battle"]["materia_thunder"][_lang]
	var thunder_lv = 1
	materia_slot1.text = thunder_text % thunder_lv
	
	var curaga_text = global.g_strings["battle"]["materia_curaga"][_lang]
	var curaga_lv = 9
	materia_slot2.text = curaga_text % curaga_lv
	
	var blizzara_text = global.g_strings["battle"]["materia_blizzara"][_lang]
	var blizzara_lv = 8
	materia_slot3.text = blizzara_text % blizzara_lv

	materia_support.text = global.g_strings["battle"]["materia_support"][_lang]
#	materia_support.add_color_override("font_color", Color("333333"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.is_visible_in_tree() && manage_input):
		_get_input()


func _set_selection():
	var dialog_text = global.g_strings["battle"]["materia_spend"][_lang]
	if current_selection == 1:
		self.animation = "1"
		spell_cost = 10
		materia_dialog.text = dialog_text % spell_cost
	if current_selection == 2:
		self.animation = "2"
		spell_cost = 90
		materia_dialog.text = dialog_text % spell_cost
	if current_selection == 3:
		self.animation = "3"
		spell_cost = 35
		materia_dialog.text = dialog_text % spell_cost
	if current_selection == 4:
		self.animation = "4"
		materia_dialog.text = "???"


func _get_input():
	if (Input.is_action_just_pressed("ui_down")):
		if current_selection == 4:
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
#		print("materia menu emitting close signal")
		manage_input = false
		emit_signal("close")
		navigate_audio.play()
	if Input.is_action_just_pressed("ui_accept"):
#		print("materia menu emitting cast spell signal")
		if current_selection == 1 && player_mp >= spell_cost:
			emit_signal("cast_spell", spell_cost)
			select_audio.play()
		else:
			unavailable_audio.play()


func should_manage_input(play_audio: bool):
	manage_input = true
	if play_audio:
		select_audio.play()


func init_player_mp(mp: int):
	player_mp = mp
