extends Node2D


# https://bibo.sakura.ne.jp/ff7bc/data/character.html
var player_level: int = 1
var shotgun_hp: int = (60 * player_level) + 200
var shotgun_mp: int = (7 * player_level) + 100
var shotgun_attack_power: int = (2 * player_level) + 14
var shotgun_defence_power: int = player_level + 14

export(PackedScene) var BATTLE1: PackedScene = preload("res://Battle1.tscn")
export(PackedScene) var SCENE1_1: PackedScene = preload("res://Scene1-1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var battle = BATTLE1.instance()
	get_tree().current_scene.add_child(battle)
	if (battle.has_method("init_player_stats")):
		battle.init_player_stats(shotgun_hp, shotgun_mp)
#	var scene1_1 = SCENE1_1.instance()
#	get_tree().current_scene.add_child(scene1_1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
