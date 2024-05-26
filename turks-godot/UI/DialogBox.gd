extends Node2D


onready var dialog_box = $ContentLabel
onready var more_arrow = $MoreArrow
onready var global = get_node("/root/Global")

# TODO: import a font that supports jp and latin characters 
var lang: String = "jp"

# Called when the node enters the scene tree for the first time.
func _ready():
	lang = global.g_settings["lang"]
	pass


func show_battle_won(materia_exp, player_exp):
#	print(global.g_strings["battle"]["blizzara_exp_points"][lang])
	dialog_box.text = global.g_strings["battle"]["blizzara_exp_points"][lang] \
						+ materia_exp as String
