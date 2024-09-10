extends Node2D


# https://bibo.sakura.ne.jp/ff7bc/data/character.html
var player_level: int = 1
var shotgun_max_hp: int = (60 * player_level) + 200
var shotgun_hp: int = shotgun_max_hp
var shotgun_max_mp: int = (7 * player_level) + 100
var shotgun_mp: int = shotgun_max_mp
var shotgun_attack_power: int = (2 * player_level) + 14
var shotgun_defence_power: int = player_level + 14

var enemy_hp: int = 20
var enemy_attack_power: int = 50 # should be 5, but 50 makes it more fun!

onready var global = get_node("/root/Global")

export(PackedScene) var TITLE: PackedScene = preload("res://Title.tscn")
export(PackedScene) var BATTLE: PackedScene = preload("res://Battle.tscn")
export(PackedScene) var SCENE1_1: PackedScene = preload("res://Scene1-1.tscn")

var title: Node = TITLE.instance()
var battle: Node = BATTLE.instance()
var scene1_1: Node = SCENE1_1.instance()

	# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.add_child(title)
	title.connect("select", self, "_on_title_language_select")
	if title.has_method("should_manage_input"):
		title.should_manage_input()
#	_load_battle()


func _on_title_language_select(lang):
	if lang == 1:
		global.g_settings["lang"] = "en"
	else:
		global.g_settings["lang"] = "jp"
	yield(get_tree().create_timer(0.5), "timeout")
	_load_scene1_1()


func _load_scene1_1():
	get_tree().current_scene.add_child(scene1_1)
	get_tree().current_scene.remove_child(title)
	scene1_1.connect("load_battle_1", self, "_on_scene1_1_load_battle_1")
	scene1_1.connect("load_battle_2", self, "_on_scene1_1_load_battle_2")


func _on_scene1_1_load_battle_1():
#	print("signal received: _on_scene1_1_load_battle_1")
	get_tree().current_scene.remove_child(scene1_1)
	_load_battle(global.g_ORDINAL.FIRST)


func _on_scene1_1_load_battle_2():
#	print("signal received: _on_scene1_1_load_battle_2")
	get_tree().current_scene.remove_child(scene1_1)
	battle = BATTLE.instance()
	_load_battle(global.g_ORDINAL.SECOND)


func _on_battle_player_won_battle(battle_index):
	get_tree().current_scene.remove_child(battle)
	battle.queue_free()
	get_tree().current_scene.add_child(scene1_1)
	if battle_index == global.g_ORDINAL.FIRST:
		if scene1_1.has_method("_transition_from_battle1"):
			scene1_1._transition_from_battle1()
	if battle_index == global.g_ORDINAL.SECOND:
		if scene1_1.has_method("_transition_from_battle2"):
			scene1_1._transition_from_battle2()


func _on_battle_player_stats_changed(player_hp, player_mp):
	shotgun_hp = player_hp
	shotgun_mp = player_mp


func _load_battle(battle_index):
	get_tree().current_scene.add_child(battle)
	battle.connect("player_won_battle", self, "_on_battle_player_won_battle")
	battle.connect("player_stats_changed", self, "_on_battle_player_stats_changed")
	if battle.has_method("init_player_stats"):
		battle.init_player_stats(shotgun_max_hp, shotgun_hp, shotgun_max_mp, shotgun_mp, shotgun_attack_power)
	if battle_index == global.g_ORDINAL.FIRST:
		if battle.has_method("set_battle_index"):
			battle.set_battle_index(global.g_ORDINAL.FIRST)
	elif battle_index == global.g_ORDINAL.SECOND:
		if battle.has_method("set_battle_index"):
			battle.set_battle_index(global.g_ORDINAL.SECOND)
	else:
		print("_load_battle: unknown battle index [",battle_index,"]")
	# init enemy stats AFTER they've been added to the scene (as part of set_battle_index)
	if battle.has_method("init_enemy_stats"):
		battle.init_enemy_stats(enemy_hp, enemy_attack_power)
