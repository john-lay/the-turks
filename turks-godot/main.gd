extends Node2D


# https://bibo.sakura.ne.jp/ff7bc/data/character.html
var player_level: int = 1
var shotgun_hp: int = (60 * player_level) + 200
var shotgun_mp: int = (7 * player_level) + 100
var shotgun_attack_power: int = (2 * player_level) + 14
var shotgun_defence_power: int = player_level + 14

var enemy_hp: int = 20
var enemy_attack_power: int = 5

export(PackedScene) var BATTLE1: PackedScene = preload("res://Battle1.tscn")
export(PackedScene) var SCENE1_1: PackedScene = preload("res://Scene1-1.tscn")

var scene_battle: Node = BATTLE1.instance()
var scene1_1: Node = SCENE1_1.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.add_child(scene_battle)
	scene_battle.connect("player_won_battle", self, "_on_battle_player_won_battle")
	if (scene_battle.has_method("init_player_stats")):
		scene_battle.init_player_stats(shotgun_hp, shotgun_mp, shotgun_attack_power)
	if (scene_battle.has_method("init_enemy_stats")):
		scene_battle.init_enemy_stats(enemy_hp, enemy_attack_power)


func _on_battle_player_won_battle():
	get_tree().current_scene.remove_child(scene_battle)
	var scene1_1 = SCENE1_1.instance()
	get_tree().current_scene.add_child(scene1_1)
