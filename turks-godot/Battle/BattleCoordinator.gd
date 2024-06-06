extends Node2D

# Declare member variables here. Examples:
onready var player = $player
onready var enemy = $enemy
onready var health_bar = $HealthBar
onready var health_label = $HealthLabel
onready var magic_bar = $MagicBar
onready var game_over = $GameOver
onready var dialog_box = $DialogBox
onready var materia_menu = $MateriaMenu
onready var cast_magic = $CastMagic
onready var global = get_node("/root/Global")

var player_max_hp: int
var player_hp: int
var player_max_mp: int
var player_mp: int
var has_shown_dialog: bool = false
signal player_won_battle

# Called when the node enters the scene tree for the first time.
func _ready():
	_enable_player_attack()
	game_over.visible = false
	dialog_box.visible = false
	materia_menu.visible = false
	cast_magic.visible = false
	_show_enemy_info_dialog_box()


func _show_enemy_info_dialog_box():
	_disable_actors()
	if (dialog_box.has_method("write_pages")):
		var enemy_lv = 1
		var pathToPageSentence = ["battle", "avalanche_soldier"]
		var formatPageSentence = [enemy_lv]
		var pageline = global.DialogLine.new(pathToPageSentence, formatPageSentence)
		var page = global.DialogPage.new([pageline])
		var pages: Array = [page]

		dialog_box.write_pages(pages, global.g_DIALOG_TYPE.BATTLE_INIT_ENEMY)
		dialog_box.visible = true


func _enable_actors():
	if (player.has_method("enable_player")):
		player.enable_player()
	if (enemy.has_method("enable_enemy")):
		enemy.enable_enemy()


func _disable_actors():
	if (player.has_method("disable_player")):
		player.disable_player()
	if (enemy.has_method("disable_enemy")):
		enemy.disable_enemy()


func _enable_player_attack():
	if (player.has_method("enable_attack")):
		player.enable_attack()


func _on_enemy_request_player_position():
	if (enemy.has_method("player_position_received")):
		enemy.player_position_received(player.position)


func init_player_stats(hp: int, mp: int, attack_power: int):
	player_max_hp = hp
	player_hp = hp
	health_label.text = player_hp as String + "/" + player_max_hp as String
	health_bar.value = (player_hp / player_max_hp) * 100
	if (player.has_method("init_player_health")):
		player.init_player_health(hp)
	if (player.has_method("init_player_attack_power")):
		player.init_player_attack_power(attack_power)
	
	player_max_mp = mp
	player_mp = mp
	magic_bar.value = (player_mp / player_max_mp) * 100


func init_enemy_stats(hp: int, attack_power: int):
	if (enemy.has_method("init_enemy_stats")):
		enemy.init_enemy_stats(hp, attack_power)


func _on_player_player_health_changed(health):
	player_hp = health
	health_label.text = player_hp as String + "/" + player_max_hp as String
	health_bar.value = (player_hp as float / player_max_hp as float) * 100


func _on_player_player_died():
	game_over.visible = true
	get_tree().paused = true


func _on_enemy_enemy_died():
	if (player.has_method("disable_player")):
		player.disable_player()
	if (!has_shown_dialog):
		has_shown_dialog = true
		_show_exp_dialog()


func _show_exp_dialog():
	if (dialog_box.has_method("write_pages")):
		# TODO: generate exp dynamically
		var materia_exp = 1
		var player_exp = 2
		
		var pathToPage1Sentence = ["battle", "blizzara_exp_points"]
		var formatPage1Sentence = [materia_exp]
		var page1line1 = global.DialogLine.new(pathToPage1Sentence, formatPage1Sentence)
		var page1 = global.DialogPage.new([page1line1])
		
		var pathToPage2Sentence1 = ["battle", "exp_point"]
		var formatPage2Sentence1 = [player_exp]
		var page2line1 = global.DialogLine.new(pathToPage2Sentence1, formatPage2Sentence1)
		var pathToPage2Sentence2 = ["battle", "obtained"]
		var page2line2 = global.DialogLine.new(pathToPage2Sentence2)
		var page2 = global.DialogPage.new([page2line1, page2line2])
		
		var pages: Array = [page1, page2]

		dialog_box.write_pages(pages, global.g_DIALOG_TYPE.BATTLE_PLAYER_EXP)
		dialog_box.visible = true

func _return_to_map():
	# returning player to exploration mode
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("player_won_battle")


func _on_DialogBox_dialog_complete(dialog_type):
	if dialog_type == global.g_DIALOG_TYPE.BATTLE_INIT_ENEMY:
		dialog_box.visible = false
		_enable_actors()
	if dialog_type == global.g_DIALOG_TYPE.BATTLE_PLAYER_EXP:
		_return_to_map()


func _on_player_materia_menu_invoked():
	_disable_actors()
	materia_menu.visible = true


func _on_MateriaMenu_close():
	_enable_actors()
	materia_menu.visible = false


func _on_MateriaMenu_cast_spell(item):
	print("beginning casting spell for item: ", item)
	materia_menu.visible = false
	cast_magic.visible = true
