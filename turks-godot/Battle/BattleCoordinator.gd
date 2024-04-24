extends Node2D

# Declare member variables here. Examples:
onready var player = $player
onready var enemy = $enemy
onready var health_bar = $HealthBar
onready var magic_bar = $MagicBar
onready var game_over = $GameOver
var player_max_hp: int;
var player_hp: int;
var player_max_mp: int;
var player_mp: int;

# Called when the node enters the scene tree for the first time.
func _ready():
	enable_player_attack()
	
	game_over.visible = false


func enable_player_attack():
	if (player.has_method("enable_attack")):
		player.enable_attack()


func _on_enemy_request_player_position():
	if (enemy.has_method("player_position_received")):
		enemy.player_position_received(player.position)


func init_player_stats(hp: int, mp: int, attack_power: int):
	player_max_hp = hp
	player_hp = hp
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
	health_bar.value = (player_hp as float / player_max_hp as float) * 100


func _on_player_player_died():
	game_over.visible = true
	get_tree().paused = true
