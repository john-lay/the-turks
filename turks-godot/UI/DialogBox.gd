extends Node2D


signal dialog_complete


onready var dialog_box = $ContentLabel
onready var more_arrow = $MoreArrow
onready var global = get_node("/root/Global")

var lang: String = "jp"
var current_page: int = 0

var battle: Dictionary = {
	"materia_exp": 0,
	"player_exp": 0,
	"pages": 2
}

# Called when the node enters the scene tree for the first time.
func _ready():
	lang = global.g_settings["lang"]
	more_arrow.visible = false
	pass


func show_battle_won(materia_exp, player_exp):
	more_arrow.visible = true
	current_page = 1
	battle["materia_exp"] = materia_exp
	battle["player_exp"] = player_exp
	dialog_box.text = global.g_strings["battle"]["blizzara_exp_points"][lang] \
						+ "   " + battle["materia_exp"] as String


func _get_input():
	if (Input.is_action_just_pressed("ui_accept")):
		current_page+=1
		if (current_page == 2): 
			dialog_box.text = global.g_strings["battle"]["exp_point"][lang] \
							+ "            " + battle["player_exp"] as String + "\n" \
							+ global.g_strings["battle"]["obtained"][lang]
		elif (current_page > 2):
			emit_signal("dialog_complete")


func _process(_delta):
	_get_input()

